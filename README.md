# VideoPi

*video player for artists by artists*

We are Jakub and Viktor, graduates from the Academy of Fine Arts in Prague, and we know what it's like

1. to __transcode__ all the videos the night before your presentation,
2. to __burn the DVDs__ three times until the player finally accepts it,
3. to __see glitches and lags__ in your video and do the transcoding several times again until the playback is smooth,
4. to visit the exhibition and see that __your videos are not playing__ because someone forgot to press the play button or didn't turn the loop function on.

VideoPi fixes all these problems:

1. it plays virtually __any video format__ you can think of[^1],
2. from a __USB stick__[^2],
3. with __no glitches or lags__ (full HD supported),
4. and it __starts playing all videos__ on the USB stick __in a loop automatically__ right after you plug it in the electricity.

VideoPi requires no configuration at all, if you use a standard HDMI full HD video output. Some configuration is needed, though, if you require different video output.

VideoPi is extendable and open for modifications. Whether you need gamma adjustment, to play the clips in random order, or something crazy that we can't even imagine, you can do that with VideoPi. It has all the capabilities of a micro PC, in the end it's nothing but a clever Linux installation[^3]. Dig in VideoPi's [open-source code](http://lab.jakubvalenta.cz/jakub/video-pi).

## Get VideoPi

If you don't feel like installing VideoPi yourself (which you totally can, by the way, if you know the basics of Linux), we can

- __lend you a VideoPi__ (or two, or a dozen) for a daily price for as long as you need,
- or we can __sell it to you__, so it will be yours and yours only forever.

In either case, we will __help you with the initial configuration__ of your VideoPi.

We haven't come up with a price list yet, so just [send us an email](videopi@jakubvalenta.cz) and we'll get back to you and find a solution that will suit your needs.

---

[^1]: VideoPi uses the excellent [http://www.mpv.io/](mpv media player) with the FFmpeg library, which supports MPEG-2, H.263/MPEG-4 Part 2 (DivX, .avi, .mpeg), H.264/MPEG-4 AVC (.mp4, .mov, .mkv), Windows Media Video (.wmv), VP8 (.webm), Theora (.ogv), any many other codecs.

[^2]: VideoPi can read USB flash drives formatted on Windows (FAT, NTFS), Mac (HFS+), or Linux (ext4 etc).

[^3]: VideoPi is a set of configuration files and scripts on top of [http://www.archlinuxarm.org/](ArchLinux ARM) GNU/Linux distribution. It uses udevil to manage USB flash drive mounting and mpv to play the videos.

## Technical

### Installation

See [INSTALL.md](./INSTALL.md)

### Contributing

See [NOTICE](./NOTICE) and [LICENSE](./LICENSE) for license information.
