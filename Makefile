.DELETE_ON_ERROR:
.EXPORT_ALL_VARIABLES:

.PHONY: partition filesystems mount download unpack-arch unpack-videopi unpack-rpi unpack-my unpack-zku chroot build install build-rpi1 build-rpi2 install-rpi1 install-rpi2 backup unmount umount clean checkargs help

all: build-rpi2

build-rpi1:  ## Build VideoPi image for RaspberryPi 1.
	export version=1 && \
	export filename_archlinux_arm="ArchLinuxARM-rpi-latest.tar.gz" && \
	$(MAKE) build
	$(MAKE) umount

build-rpi2:  ## Build VideoPi image for RaspberryPi 2.
	export version=2 && \
	export filename_archlinux_arm="ArchLinuxARM-rpi-2-latest.tar.gz" && \
	$(MAKE) build
	$(MAKE) umount

install-rpi1:  ## Install VideoPi image for RaspberryPi 1 to DEVICE.
	export version=1 && \
	export filename_archlinux_arm="ArchLinuxARM-rpi-latest.tar.gz" && \
	$(MAKE) install
	$(MAKE) umount

install-rpi2:  ## Install VideoPi image for RaspberryPi 1 to DEVICE.
	export version=2 && \
	export filename_archlinux_arm="ArchLinuxARM-rpi-2-latest.tar.gz" && \
	$(MAKE) install
	$(MAKE) umount

backup: checkargs  ## Create an image of the whole DEVICE and store it to backup/.
	sh -c "dd if=$(DEVICE) bs=1024 conv=noerror,sync | pv | gzip -c -9 > backup/video-pi-backup-`date +%Y%m%d-%H%M%S`.img.gz"

erase: checkargs  ## Overwrite the whole DEVICE with zeros.
	 # pv --timer --rate --stop-at-size -s "$$(blockdev --getsize64 $(DEVICE))" /dev/zero > $(DEVICE)
	dd if=/dev/zero of="$(DEVICE)" iflag=nocache oflag=direct bs=4096

partition: checkargs
	sh -c "sfdisk $(DEVICE) < disk.dump"

filesystems: checkargs partition  ## Create partitions and filesystems on the DEVICE.
	mkfs.vfat "$(DEVICE)1"
	mkfs.ext4 "$(DEVICE)2"

mount: tmp/root tmp/boot

tmp/boot: checkargs
	mkdir -p tmp/boot
	mount "$(DEVICE)1" tmp/boot

tmp/root: checkargs
	mkdir -p tmp/root
	mount "$(DEVICE)2" tmp/root

download: cache/$(filename_archlinux_arm)

cache/%:
	mkdir -p cache
	cd cache; wget -c "http://archlinuxarm.org/os/$$(echo '$@' | sed -r 's/^cache\/(.+)$$/\1/')"

unpack-arch: tmp/root/bin/bash

tmp/root/bin/bash: mount download
	su -c "bsdtar -xpf cache/$(filename_archlinux_arm) -C tmp/root"
	sync
	-rm -r tmp/boot/*
	mv tmp/root/boot/* tmp/boot

unpack-videopi: tmp/root/home/alarm/bin/devmon-play-omxplayer.sh

tmp/root/home/alarm/bin/devmon-play-omxplayer.sh: unpack-arch
	cp -af src/* tmp/root
	mv tmp/root/boot/* tmp/boot

unpack-rpi: tmp/root/home/alarm/bin/my-autostart-xorg

tmp/root/home/alarm/bin/my-autostart-xorg: unpack-videopi
	[[ -f tmp/root/home/alarm/bin/my-autostart-xorg ]] || cp -af src-rpi$(version)/* tmp/root # check using bash because makefile doesn't recognize symbolic links

unpack-custom: unpack-rpi
ifneq (,$(CUSTOM))
	for dir in $(CUSTOM); do cp -af src-custom/$$dir/* tmp/root; done
	-mv tmp/root/boot/* tmp/boot
endif

chroot: tmp/root/usr/bin/devmon

tmp/root/usr/bin/devmon: checkargs unpack-rpi unpack-custom
	-[[ -f tmp/root/usr/bin/qemu-arm-static ]] || \
	update-binfmts --importdir /var/lib/binfmts/ --import; \
	update-binfmts --display qemu-arm; \
	update-binfmts --enable qemu-arm
	[[ -f tmp/root/usr/bin ]] || cp /usr/bin/qemu-arm-static tmp/root/usr/bin
	-umount tmp/root/dev
	-umount tmp/root/proc
	-umount tmp/root/sys
	mount "$(DEVICE)1" tmp/root/boot
	-arch-chroot tmp/root /usr/bin/qemu-arm-static /bin/bash -c "/home/alarm/install/install.sh; exit"
	umount tmp/root/boot
	[[ -f tmp/root/usr/bin/devmon ]] && touch tmp/root/usr/bin/devmon # check if chroot install succeeded

build: dist/video-pi-rpi$(version).tar.bz2

dist/video-pi-rpi%.tar.bz2: checkargs chroot
	-rm tmp/root/home/alarm/.bash_history
	-rm -r tmp/root/home/alarm/install
	-rm tmp/root/home/alarm/webcam/*
	-rm tmp/root/root/.bash_history
	-rm tmp/root/var/log/pacman.log
	-rm -r tmp/root/var/cache/pacman/pkg/*
	mount "$(DEVICE)1" tmp/root/boot
	mkdir -p dist
	cd tmp/root; su -c "bsdtar -cjf ../../$@ *"
	umount tmp/root/boot

install: mount
	su -c "bsdtar -xpf dist/video-pi-rpi$(version).tar.bz2 -C tmp/root"
	sync
	-rm -r tmp/boot/*
	mv tmp/root/boot/* tmp/boot

unmount: umount

umount:
	-umount -R tmp/root
	-rm -r tmp/root
	-umount tmp/boot
	-rm -r tmp/boot

fsck: checkargs
	fsck.vfat -a "$(DEVICE)1"
	fsck.ext4 -a "$(DEVICE)2"

clean: umount  ## Unmount DEVICE partitions and remove temp files created during the build.
	-rm dist/*

checkargs:
ifeq (,$(DEVICE))
	@echo "You must set the DEVICE variable."
	@echo "Example: make backup DEVICE=/dev/sdX"
	@exit 1
endif

help: # https://gist.github.com/jhermsmeier/2d831eb8ad2fb0803091
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-14s\033[0m %s\n", $$1, $$2}'
