arch = $(shell uname -m)
ifeq ($(arch), armv7l)
    arch = armv7h
endif

all: packages network permissions install-udevil install-mpv

.PHONY: packages network pemissions install-udevil install-mpv install-antimicro

packages: /usr/bin/omxplayer

/usr/bin/omxplayer:
	-mv /etc/sudoers /etc/sudoers.bak
	pacman -Syu --noconfirm --needed sudo
	mv /etc/sudoers.bak /etc/sudoers
	pacman -S --noconfirm --needed xorg-server xorg-server-utils xorg-xinit xf86-video-fbdev xorg-apps xorg-bdftopcf xorg-iceauth xorg-luit xorg-mkfontdir xorg-mkfontscale xorg-sessreg xorg-setxkbmap xorg-smproxy xorg-x11perf xorg-xauth xorg-xbacklight xorg-xcmsdb xorg-xcursorgen xorg-xdpyinfo xorg-xdriinfo xorg-xev xorg-xgamma xorg-xhost xorg-xinput xorg-xkbcomp xorg-xkbevd xorg-xkbutils xorg-xkill xorg-xlsatoms xorg-xlsclients xorg-xmodmap xorg-xpr xorg-xprop xorg-xrandr xorg-xrdb xorg-xrefresh xorg-xset xorg-xsetroot xorg-xvinfo xorg-xwd xorg-xwininfo xorg-xwud xorg-fonts \
	dwm dmenu feh \
	xterm rxvt-unicode terminus-font \
	wpa_supplicant motion \
	links \
	pulseaudio-alsa alsa-utils pavucontrol \
	mplayer omxplayer mpv

network: /etc/udev/rules.d/80-net-setup-link.rules

/etc/udev/rules.d/80-net-setup-link.rules:
	 # pacman -S --noconfirm --needed dkms-8188eu dkms-8192cu
	ln -s /dev/null /etc/udev/rules.d/80-net-setup-link.rules
	netctl enable my-network

permissions:
	gpasswd -a alarm wheel
	gpasswd -a alarm video

install-udevil: udevil-git/udevil-git-20151016.216-1-$(arch).pkg.tar.xz
	pacman -U --noconfirm --needed "udevil-git/udevil-git-20151016.216-1-$(arch).pkg.tar.xz"

udevil-git/udevil-git-%.pkg.tar.xz:
	[[ -f /usr/bin/fakeroot ]] || pacman -S --noconfirm --needed base-devel ccache
	pacman -S --noconfirm --needed git intltool --asdeps
	su - alarm sh -c "cd /home/alarm/install/udevil-git; makepkg"

install-mpv: mpv/mpv-1\:0.20.0-1-$(arch).pkg.tar.xz
	pacman -U --noconfirm --needed "mpv/mpv-1:0.20.0-2-$(arch).pkg.tar.xz"

mpv/mpv-%.pkg.tar.xz:
	[[ -f /usr/bin/fakeroot ]] || pacman -S --noconfirm --needed base-devel ccache
	pacman -S --noconfirm --needed ffmpeg lcms2 libcdio-paranoia enca libxss libxkbcommon libcaca desktop-file-utils hicolor-icon-theme xdg-utils lua52 libdvdnav libguess jack smbclient rubberband python-docutils ladspa hardening-wrapper --asdeps
	su - alarm sh -c "cd /home/alarm/install/mpv; makepkg"

install-antimicro: antimicro/antimicro-2.21-1-$(arch).pkg.tar.xz
	pacman -U --noconfirm --needed "antimicro/antimicro-2.21-1-$(arch).pkg.tar.xz"

antimicro/antimicro-%.pkg.tar.xz:
	[[ -f /usr/bin/fakeroot ]] || pacman -S --noconfirm --needed base-devel ccache
	pacman -S --noconfirm --needed libxkbcommon-x11 qt5-base itstool qt5-tools sdl2 cmake --asdeps
	su - alarm sh -c "cd /home/alarm/install/antimicro; makepkg"
