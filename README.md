# VideoPi

*video player for artists by artists*

Hi, we're Jakub and Viktor, graduates from an art university, and we know what it's like

1. to __transcode__ all your videos the night before your presentation,
2. to __burn the DVDs__ three times until the player finally accepts them,
3. to __see glitches and lags__ in your video and do the transcoding several times again until the playback is smooth,
4. to visit the exhibition and see that __your videos are not playing__ because someone forgot to press the play button or didn't turn the loop function on.

VideoPi fixes all these problems:

1. it plays virtually __any video format__ you can think of[^1],
2. from a __USB stick__[^2],
3. with __no glitches or lags__ (full HD supported),
4. and it __starts playing all videos__ on the USB stick __in a loop automatically__; you just connect the power cord.

VideoPi requires no configuration for the most common use case -- HDMI full HD video output with a separate 3.5mm jack audio output.

VideoPi can also capture images using a __webcam__ and upload them to your server.

VideoPi is extendable and open for modifications. You can modify VideoPi to do video post-processing like gamma adjustment, or to play the clips in random order, or to do something we couldn't even imagine. VideoPi has all the capabilities of a micro PC; in the end it's nothing but a clever Linux installation[^3]. Dig in VideoPi's [open-source code](http://lab.saloun.cz/jakub/video-pi).

## Get VideoPi

If you don't feel like installing VideoPi yourself (which you totally can, by the way, if you know the basics of Linux), we can

- __lend you a VideoPi__ (or two, or a dozen) for a daily price for as long as you need,
- or we can __sell it to you__, so it will be yours and yours only forever.

In either case, we will __help you with the initial setup__.

We haven't come up with a price list or the exact extent of provided support and maintenance yet, so just [send us an email](mailto:17bda853@opayq.com) and we'll get back to you.

## Help

VideoPi aims for simplicity and zero configuration, therefore:

- Make sure the __HDMI cable__ is connected before you power on VideoPi.
- By default, the __sound__ will play from the 3.5mm jack not from the HDMI.
- __Volume__ adjustment is not available. Adjust the volume on your speakers.
- Video files will play in __alphabetic order__. If you want to be sure of particular file order, name your files with numbers or lowercase letters and use only latin characters.
- File names with __non-latin characters__ (such as chinese or cyrillic) as well as special characters (such as punctuation) are supported but should be avoided; especially if you care about the playback order.
- The __loop__ (repeat all) function cannot be turned off.
- To setup the __webcam__ you need to have an internet connection and a server with remote SSH access, see the [Webcam section](#webcam) for more info.

## Technical

__WARNING:__ Following documentation uses `/dev/sdX` as a substitute for your real SD card device path. Double check this path before executing the installer (Makefile), so that you don't accidentally overwrite a different device.

### Requirements

Required Arch Linux packages (should be similar on other distributions):

```
util-linux (sfdisk)
dosfstools (mkfs.vfat)
e2fsprogs (mkfs.ext4)
make
wget

arch-install-scripts (arch-chroot) # Installation only
binfmt-support (update-binftms) # Installation only
qemu-user-static (qemu-arm-static) # Installation only
```

### Install VideoPi on an SD card

First format your SD card:

```shell
# make erase filesystems DEVICE=/dev/sdX
```

Then install VideoPi for your Raspberry Pi version on the SD card and create a disk image of the whole card:

```shell
# make VERSION=2 DEVICE=/dev/sdX
```

Supported Raspberry Pi version are `VERSION=1`, `2` and `3`.

### Unpack a VideoPi image

After you've created an SD card image (see previous section), you can unpack it to another SD card without having to go through the installation again:

```shell
# make mount unpack umount VERSION=2 DEVICE=/dev/sdX
```

### More

See the Makefile help for all available commands:

```shell
$ make help
```

#### Customize

To customize the installation (add or replace some files on the SD card), select one of the available modifications from `src-custom/` or create your own and pass appropriate `CUSTOM=` parameter to `make`. Example:

```shell
$ mkdir -p src-custom/my-improvement/home/alarm
$ echo "bar" > src-custom/my-improvement/home/alarm/foo
# make VERSION=2 DEVICE=/dev/sdX CUSTOM="my-improvement"
```

##### Shuffle

Use modification `shuffle` to play the video files in random order:

```shell
# make VERSION=2 DEVICE=/dev/sdX CUSTOM="shuffle"
```

##### Multiple modifications

To use multiple modifications put a space separated list in the parameter `CUSTOM=`:

```shell
# make VERSION=2 DEVICE=/dev/sdX CUSTOM="shuffle my-improvement"
```

##### Network

To setup a network connection create a new netctl network config (possibly based on `src/etc/netctl/example`) in a new modifications directory and rebuild the image:

```shell
$ mkdir -p src-custom/my-home-network/etc/netctl
$ echo "my netctl content" > src-custom/my-home-network/etc/netctl/home
$ rm src-custom/my-home-network/etc/netctl/my-network
$ ln -s src-custom/my-home-network/etc/netctl/home src-custom/my-home-network/etc/netctl/my-network
# make VERSION=2 DEVICE=/dev/sdX CUSTOM="my-home-network"
```

##### Webcam

To setup a webcam image upload you need a working [Network connection](#network) and SSH. Copy example SSH config files from `src/` and edit them to match your server settings:

```shell
$ mkdir -p src-custom/my-server/home/alarm/.ssh
$ cp src/home/alarm/.ssh/config src-custom/my-server/home/alarm/.ssh/
$ cd src-custom/my-server/home/alarm/.ssh
$ nano known_hosts
$ echo "" > id_rsa
$ nano config
```

Then edit your remote server directory:

```shell
$ cp src/home/alarm/bin/upload-image src-custom/my-server/home/alarm/bin/upload-image
$ nano src-custom/my-server/home/alarm/bin/upload-image
```

...and build the image:

```shell
# make VERSION=2 DEVICE=/dev/sdX CUSTOM="my-home-network my-server"
```

### Troubleshooting

The log is located in `/home/alarm/.log/devmon.log`.

### License

Copyright 2016 Jakub Valenta

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

[^1]: VideoPi uses the excellent [mpv media player](http://www.mpv.io/) with the FFmpeg library, which supports MPEG-2, H.263/MPEG-4 Part 2 (DivX, .avi, .mpeg), H.264/MPEG-4 AVC (.mp4, .mov, .mkv), Windows Media Video (.wmv), VP8 (.webm), Theora (.ogv), and many other codecs.

[^2]: VideoPi reads USB flash drives formatted on Windows (FAT, NTFS), Mac (HFS+), or Linux (ext4 etc).

[^3]: VideoPi is a set of configuration files and scripts on top of [ArchLinux ARM](http://www.archlinuxarm.org) GNU/Linux distribution. It uses udevil to manage USB flash drive mounting and mpv to play the videos.
