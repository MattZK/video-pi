.DELETE_ON_ERROR:
.EXPORT_ALL_VARIABLES:

.PHONY: partition filesystems mount download unpack_arch unpack_videopi unpack_rpi unpack_my unpack_zku chroot build install install_rpi1 install_rpi2 backup unmount umount clean checkargs

all: build_rpi2

partition: checkargs
	sh -c "sfdisk $(DEVICE) < disk.dump"

filesystems: checkargs partition
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

cache/*:
	cd cache; wget -c "http://archlinuxarm.org/os/$@"

unpack_arch: tmp/root/bin/bash

tmp/root/bin/bash: tmp/boot tmp/root cache/$(filename_archlinux_arm)
	su -c "bsdtar -xpf cache/$(filename_archlinux_arm) -C tmp/root"
	sync
	-rm -r tmp/boot/*
	mv tmp/root/boot/* tmp/boot

unpack_videopi: tmp/root/home/alarm/bin/devmon-play-omxplayer.sh

tmp/root/home/alarm/bin/devmon-play-omxplayer.sh: tmp/root/bin/bash
	cp -af src/* tmp/root
	mv tmp/root/boot/* tmp/boot

unpack_rpi: tmp/root/home/alarm/bin/my-autostart-xorg

tmp/root/home/alarm/bin/my-autostart-xorg: tmp/root/home/alarm/bin/devmon-play-omxplayer.sh
	[[ -f tmp/root/home/alarm/bin/my-autostart-xorg ]] || cp -af src-rpi$(version)/* tmp/root # check using bash because makefile doesn't recognize symbolic links

unpack_custom: tmp/root/home/alarm/bin/my-autostart-xorg
ifneq (,$(CUSTOM))
	for dir in $(CUSTOM); do cp -af src-custom/$$dir/* tmp/root; done
	-mv tmp/root/boot/* tmp/boot
endif

chroot: tmp/root/usr/bin/devmon

tmp/root/usr/bin/devmon: checkargs tmp/root/home/alarm/bin/my-autostart-xorg unpack_custom
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

dist/video-pi-rpi%.tar.bz2: checkargs tmp/root/usr/bin/devmon
	-rm tmp/root/home/alarm/.bash_history
	-rm -r tmp/root/home/alarm/install
	-rm tmp/root/home/alarm/webcam/*
	-rm tmp/root/root/.bash_history
	-rm tmp/root/var/log/pacman.log
	-rm -r tmp/root/var/cache/pacman/pkg/*
	mount "$(DEVICE)1" tmp/root/boot
	cd tmp/root; su -c "bsdtar -cjf ../../$@ *"
	umount tmp/root/boot

install: tmp/boot tmp/root dist/video-pi-rpi$(version).tar.bz2
	su -c "bsdtar -xpf dist/video-pi-rpi$(version).tar.bz2 -C tmp/root"
	sync
	-rm -r tmp/boot/*
	mv tmp/root/boot/* tmp/boot

backup: checkargs
	sh -c "dd if=$(DEVICE) bs=1024 conv=noerror,sync | pv | gzip -c -9 > backup/video-pi-backup-`date +%Y%m%d-%H%M%S`.img.gz"

unmount: umount

umount:
	-umount -R tmp/root
	-rm -r tmp/root
	-umount tmp/boot
	-rm -r tmp/boot

build_rpi1:
	export version=1 && \
	export filename_archlinux_arm="ArchLinuxARM-rpi-latest.tar.gz" && \
	$(MAKE) build
	$(MAKE) umount

build_rpi2:
	export version=2 && \
	export filename_archlinux_arm="ArchLinuxARM-rpi-2-latest.tar.gz" && \
	$(MAKE) build
	$(MAKE) umount

install_rpi1:
	export version=1 && \
	export filename_archlinux_arm="ArchLinuxARM-rpi-latest.tar.gz" && \
	$(MAKE) install
	$(MAKE) umount

install_rpi2:
	export version=2 && \
	export filename_archlinux_arm="ArchLinuxARM-rpi-2-latest.tar.gz" && \
	$(MAKE) install
	$(MAKE) umount

clean: umount
	-rm dist/*

checkargs:
ifeq (,$(DEVICE))
	exit 1
endif
