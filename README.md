# Phonecam

![Phonecam in the bar](preview.png)

Use the camera and the microphone of a OnePlus 5 as a webcam and a
microphone of this computer. The picture appears as the video device
**OnePlus 5 Camera** (`/dev/video*`, V4L2), so every video-conference
application can use it. The microphone appears as the audio source
**OnePlus 5 Microphone**. A bar widget starts and stops the stream and turns
the picture.

## How it works

- The picture: the phone sends H.264 over USB (adb, scrcpy). scrcpy writes it
  into a v4l2loopback device named `OnePlus 5 Camera`.
- The sound: scrcpy sends the microphone as Opus. A PipeWire null sink and a
  remap source expose it as `OnePlus 5 Microphone`. The sink and the source
  exist only while the stream runs.
- The device uses `exclusive_caps=1`. An application can open the camera only
  while the stream runs.

## Requirements

- An Omarchy (Quattro) desktop
- An Arch-based Linux with kernel headers (the DKMS module builds against
  them)
- These packages:

  ```sh
  sudo pacman -S scrcpy android-tools android-udev v4l2loopback-dkms \
    v4l2loopback-utils ffmpeg pulseaudio-utils
  ```

- An Android phone with USB debugging. Tested on a OnePlus 5 with
  LineageOS 22 (Android 15).

## Install

1. Install the packages (above).
2. Add this plugin:

   ```sh
   omarchy plugin add https://github.com/kguenel/omarchy-phonecam
   ```

3. Restart the shell: `omarchy restart shell`
4. Build the kernel module. It asks for the password in a terminal window:

   ```sh
   ~/.config/omarchy/plugins/kguenel.phonecam/bin/phonecam-setup
   ```

5. Connect the phone by USB, unlock it, and accept the USB-debugging question.
6. Left-click the camera icon in the bar.

The setup script is safe to run again. Run it after a kernel update if the
virtual camera is missing.

## Use

| Action | Result |
|--------|--------|
| Left click | Start or stop the camera stream |
| Right click | Next picture rotation |
| Wheel up / down | Next / previous rotation |
| Middle click | Preview window |

From a terminal, the command lives in the plugin directory. Add an alias to
`~/.bashrc`:

```sh
alias phonecam="$HOME/.config/omarchy/plugins/kguenel.phonecam/bin/phonecam"
```

| Command | Result |
|---------|--------|
| `phonecam start` / `stop` | Start or stop the stream |
| `phonecam status` | Show the state, the device, the camera, the rotation |
| `phonecam camera <n>` | Use another camera of the phone (0..3) |
| `phonecam mic on` / `off` | Use or stop using the phone microphone |
| `phonecam mirror on` / `off` / `toggle` | Mirror the picture |
| `phonecam rotate` / `cycle-rotation` / `prev-rotation` | Rotate the picture |
| `phonecam preview` | Show the picture in a window |
| `phonecam is-running` | Exit 0 while the stream runs |

The bar widget also answers
`omarchy-shell kguenel.phonecam <toggle\|start\|stop\|rotate\|preview\|mirror\|status>`.

## Remove

```sh
omarchy plugin remove kguenel.phonecam
```

Optional, if you do not want the virtual camera any more:

```sh
sudo rm /etc/modprobe.d/v4l2loopback.conf /etc/modules-load.d/v4l2loopback.conf
sudo rmmod v4l2loopback
rm -rf "$HOME/.config/phonecam"
```

## Notes

- The stream is a background `scrcpy` process. The phone shows a
  microphone-in-use indicator while it runs.
- The virtual camera is owned by `root:video`. The logged-in user gets access
  to it by an ACL for the local session (`user:...:rw-`). If your session does
  not get that ACL, add your user to the `video` group.
- One reader only: while a conference application holds the camera, the
  preview and the stream cannot open it again. Stop the stream first.
- The plugin runs unsandboxed, like every Omarchy plugin. It spawns
  `scrcpy`, `ffplay` (preview) and `pactl` (microphone) processes, and writes
  its state under `~/.config/phonecam`. The setup script needs root once,
  for the kernel module and its boot configuration.

## License

[MIT](LICENSE)
