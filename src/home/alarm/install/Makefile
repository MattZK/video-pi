arch = $(shell uname -m)
ifeq ($(arch), armv7l)
    arch = armv7h
endif

all: upgrade gui sound player udevil permissions

.PHONY: upgrade gui sound player network webcam permissions udevil mpv antimicro

upgrade:
	-mv /etc/sudoers /etc/sudoers.bak
	pacman -Syu --noconfirm --needed sudo
	mv /etc/sudoers.bak /etc/sudoers
	chown root.root /etc/sudoers

gui: /usr/bin/X /usr/bin/dwm /usr/bin/xterm

sound: /usr/bin/amixer

player: mpv

network: /usr/bin/wpa_supplicant /etc/udev/rules.d/80-net-setup-link.rules

webcam: /usr/bin/motion

permissions:
	gpasswd -a alarm wheel
	gpasswd -a alarm video

/usr/bin/X:
	pacman -S --noconfirm --needed xorg-server xorg-server-utils xorg-xinit xf86-video-fbdev xorg-apps xorg-bdftopcf xorg-iceauth xorg-luit xorg-mkfontdir xorg-mkfontscale xorg-sessreg xorg-setxkbmap xorg-smproxy xorg-x11perf xorg-xauth xorg-xbacklight xorg-xcmsdb xorg-xcursorgen xorg-xdpyinfo xorg-xdriinfo xorg-xev xorg-xgamma xorg-xhost xorg-xinput xorg-xkbcomp xorg-xkbevd xorg-xkbutils xorg-xkill xorg-xlsatoms xorg-xlsclients xorg-xmodmap xorg-xpr xorg-xprop xorg-xrandr xorg-xrdb xorg-xrefresh xorg-xset xorg-xsetroot xorg-xvinfo xorg-xwd xorg-xwininfo xorg-xwud xorg-fonts

/usr/bin/dwm:
	pacman -S --noconfirm dwm dmenu feh

/usr/bin/xterm:
	pacman -S --noconfirm xterm terminus-font

/usr/bin/amixer:
	pacman -S --noconfirm alsa-utils

/usr/bin/wpa_supplicant:
	pacman -S --noconfirm wpa_supplicant links

/usr/bin/motion:
	pacman -S --noconfirm motion

/etc/udev/rules.d/80-net-setup-link.rules:
	 # pacman -S --noconfirm --needed dkms-8188eu dkms-8192cu
	ln -s /dev/null /etc/udev/rules.d/80-net-setup-link.rules
	netctl enable my-network

udevil: udevil-git/udevil-git-20151016.216-1-$(arch).pkg.tar.xz
	pacman -U --noconfirm --needed "udevil-git/udevil-git-20151016.216-1-$(arch).pkg.tar.xz"

udevil-git/udevil-git-%.pkg.tar.xz:
	[[ -f /usr/bin/fakeroot ]] || pacman -S --noconfirm --needed base-devel ccache
	pacman -S --noconfirm --needed git intltool --asdeps
	su - alarm sh -c "cd /home/alarm/install/udevil-git; makepkg"

mpv: mpv/mpv-1\:0.22.0-1-$(arch).pkg.tar.xz
	pacman -U --noconfirm --needed "mpv/mpv-1:0.22.0-1-$(arch).pkg.tar.xz"

mpv/mpv-%.pkg.tar.xz:
	[[ -f /usr/bin/fakeroot ]] || pacman -S --noconfirm --needed base-devel ccache
	pacman -S --noconfirm --needed ffmpeg lcms2 libcdio-paranoia enca libxss libxkbcommon libcaca desktop-file-utils hicolor-icon-theme xdg-utils lua52 libdvdnav libguess jack smbclient rubberband python-docutils ladspa hardening-wrapper --asdeps
	su - alarm sh -c "cd /home/alarm/install/mpv; makepkg"

antimicro: antimicro/antimicro-2.21-1-$(arch).pkg.tar.xz
	pacman -U --noconfirm --needed "antimicro/antimicro-2.21-1-$(arch).pkg.tar.xz"

antimicro/antimicro-%.pkg.tar.xz:
	[[ -f /usr/bin/fakeroot ]] || pacman -S --noconfirm --needed base-devel ccache
	pacman -S --noconfirm --needed libxkbcommon-x11 qt5-base itstool qt5-tools sdl2 cmake --asdeps
	su - alarm sh -c "cd /home/alarm/install/antimicro; makepkg"
