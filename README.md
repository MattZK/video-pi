# Video Pi

*video player for artists by artists*

We are Jakub and Viktor, graduates from the Academy of Fine Arts in Prague, and we know what it's like

1. to __transcode__ all the videos the night before your presentation,
2. to __burn the DVDs__ three times until the player finally accepts them,
3. to __see glitches and lags__ in your video and do the transcoding several times again until the playback is smooth,
4. to visit the exhibition and see that __your videos are not playing__ because someone forgot to press the play button or didn't turn the loop function on.

Video Pi fixes all these problems:

1. it plays virtually __any video format__ you can think of[^1],
2. from a __USB stick__[^2],
3. with __no glitches or lags__ (full HD supported),
4. and it __starts playing all videos__ on the USB stick __in a loop automatically__ right after you plug it in the electricity.

Video Pi requires no configuration for the most common use case -- HDMI full HD video output with a separate 3.5mm jack audio output.

Video Pi can also capture images using a __webcam__ and upload them to your server.

Video Pi is extendable and open for modifications. You can modify Video Pi to do video post-processing like gamma adjustment, or to play the clips in random order, or to do something we couldn't even imagine. Video Pi has all the capabilities of a micro PC; in the end it's nothing but a clever Linux installation[^3]. Dig in Video Pi's [open-source code](http://lab.saloun.cz/jakub/video-pi).

## Get Video Pi

If you don't feel like installing Video Pi yourself (which you totally can, by the way, if you know the basics of Linux), we can

- __lend you a Video Pi__ (or two, or a dozen) for a daily price for as long as you need,
- or we can __sell it to you__, so it will be yours and yours only forever.

In either case, we will __help you with the initial setup__.

We haven't come up with a price list or the exact extend of support and maintenance offered yet, so just [send us an email](mailto:jakub@jakubvalenta.cz) and we'll get back to you and find a solution that will suit your needs.

## Help

Video Pi aims for simplicity and zero configuration, therefore:

- Make sure the __HDMI cable__ is connected before you power on Video Pi.
- By default, the __sound__ will play from the 3.5mm jack, not from the HDMI.
- __Volume__ adjustment is not available. Adjust the volume on your speakers.
- Video files will play in __alphabetic order__. If you want to be sure of particular file order, name your files with numbers or lowercase letters and use only latin characters.
- __Non-latin characters__ (such as accented latin characters or chinese characters) as well as special characters (such as punctuation) are supported in file names, but should rather be avoided.
- The __loop__ (repeat all) function cannot be turned of.
- To setup the __webcam__ you need to have an internet connection and a server with remote SSH access, see the [Webcam section](#Webcam) for more info.

## Technical

### Install pre-built Video Pi image

Required packages:

```
util-linux (sfdisk)
dosfstools (mkfs.vfat)
e2fsprogs (mkfs.ext4)
make
wget
```

Format SD card and install image for Raspberry Pi 1:

```
sudo make DEVICE=/dev/sdX filesystems install-rpi1
```

Format SD card and Install image for Raspberry Pi 2:

```
sudo make DEVICE=/dev/sdX filesystems install-rpi2
```

Install image without formating SD card:

```
sudo make DEVICE=/dev/sdX install_rpi1
sudo make DEVICE=/dev/sdX install_rpi2
```

### Build Video Pi image

Currently the build scripts work on Arch Linux only, because they use Arch-modified chroot.

Required packages:

```
util-linux (sfdisk)
dosfstools (mkfs.vfat)
e2fsprogs (mkfs.ext4)
make
wget
arch-install-scripts
binfmt-support
qemu-user-static
```

Build image for Raspberry Pi 1:

```
sudo make DEVICE=/dev/sdX clean build-rpi1
```

Build image for Raspberry Pi 2:

```
sudo make DEVICE=/dev/sdX clean build-rpi2
```

#### Customize

To customize the image (add or replace some files on the SD card), select one of the available modifications from `src-custom/` or create you own and pass appropriate `CUSTOM=` parameter to `make`. Example:

```
mkdir -p src-custom/my-improvement/home/alarm
echo "bar" > src-custom/my-improvement/home/alarm/foo
sudo make DEVICE=/dev/sdX CUSTOM="my-improvement" clean build-rpi2
```

##### Shuffle

Use modification `shuffle` to play the video files in random order:

```
sudo make DEVICE=/dev/sdX CUSTOM="shuffle" clean build-rpi2
```

##### Multiple modifications

To use multiple modifications put a space separated list in the parameter `CUSTOM=`:

```
sudo make DEVICE=/dev/sdX CUSTOM="shuffle my-improvement" clean build-rpi2
```

##### Network

To setup a network connection create a new netctl network config (possibly based on `src/etc/netctl/example`) in a new modifications directory and rebuild the image:

```
mkdir -p src-custom/my-home-network/etc/netctl
echo "my netctl content" > src-custom/my-home-network/etc/netctl/home
rm src-custom/my-home-network/etc/netctl/my-network
ln -s src-custom/my-home-network/etc/netctl/home src-custom/my-home-network/etc/netctl/my-network
sudo make DEVICE=/dev/sdX CUSTOM="my-home-network" clean build-rpi2
```

##### Webcam

To setup a webcam image upload you need a working [Network connection](#Network) and SSH. Copy example SSH config files from `src/` and edit them to match your server configuration:

```
mkdir -p src-custom/my-server/home/alarm/.ssh/
cp src/home/alarm/.ssh/config src-custom/my-server/home/alarm/.ssh/
cd src-custom/my-server/home/alarm/.ssh/
nano known_hosts
echo "" > id_rsa
nano config
```

Then edit your remote server directory:

```
cp src/home/alarm/bin/upload-image src-custom/my-server/home/alarm/bin/upload-image
nano src-custom/my-server/home/alarm/bin/upload-image
```

And build the image:

```
sudo make DEVICE=/dev/sdX CUSTOM="my-home-network my-server" clean build-rpi2
```

### Troubleshooting

The log is located in `/home/alarm/.log/devmon.log`.

### Contributing

See [NOTICE](./NOTICE) and [LICENSE](./LICENSE) for license information.

[^1]: Video Pi uses the excellent [http://www.mpv.io/](mpv media player) with the FFmpeg library, which supports MPEG-2, H.263/MPEG-4 Part 2 (DivX, .avi, .mpeg), H.264/MPEG-4 AVC (.mp4, .mov, .mkv), Windows Media Video (.wmv), VP8 (.webm), Theora (.ogv), any many other codecs.

[^2]: Video Pi can read USB flash drives formatted on Windows (FAT, NTFS), Mac (HFS+), or Linux (ext4 etc).

[^3]: Video Pi is a set of configuration files and scripts on top of [http://www.archlinuxarm.org/](ArchLinux ARM) GNU/Linux distribution. It uses udevil to manage USB flash drive mounting and mpv to play the videos.
