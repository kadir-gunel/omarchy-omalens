# omalens manual

The camera of the OnePlus 5 is a webcam for this computer.

## 1. The parts

| Part | Function |
|------|----------|
| `/dev/video10` | The video device. Its name is "OmaLens Camera". Every program that uses a webcam finds it. |
| `omalens` | The control command, in the plugin directory (section 11). |
| The bar widget | The same control in the status bar. |
| "OmaLens Microphone" | The sound of the phone microphone, as a microphone of the computer. |
| `omalens-setup` | The repair command, in the plugin directory (section 11). It builds the kernel module again. |

The program scrcpy sends the camera picture from the phone to the video device.
The phone connects with the USB cable. The phone needs the setting "USB
debugging" in the developer options.

## 2. Start and stop the camera

Do these steps:

1. Connect the phone with the USB cable.
2. Start the camera stream.
3. Open the conference application.
4. Select "OmaLens Camera".

Do step 2 before step 3. The video device uses `exclusive_caps=1`. Therefore an
application finds the camera only while the stream runs.

The bar widget always runs the command in the plugin directory. A terminal
can use the short name with the alias from section 10.

Command form:

    omalens start      start the camera stream in the background
    omalens stop       stop the camera stream
    omalens status     show the state, the device, the camera and the rotation
    omalens camera     show the camera in use and the cameras of the phone

## 3. The bar widget

The bar shows a camera icon.

| Action | Result |
|--------|--------|
| Left click | Start the camera stream. A second left click stops it. |
| Right click | Use the next rotation of the picture. |
| Middle click | Show the picture in a preview window. |
| Wheel | Turn the picture (the next or the previous rotation). |

The wheel turns the picture without a click. The mirror and the camera have no
gesture: use the commands `omalens mirror` and `omalens camera`, or a
keybinding with `omarchy-shell kguenel.omalens mirror`.

The icon is red while the stream runs. The icon has the normal colour while the
stream is off.

A terminal can do the same actions:

    omarchy-shell kguenel.omalens toggle
    omarchy-shell kguenel.omalens start
    omarchy-shell kguenel.omalens stop
    omarchy-shell kguenel.omalens rotate
    omarchy-shell kguenel.omalens preview
    omarchy-shell kguenel.omalens status

## 4. Choose the camera of the phone

The OnePlus 5 has four cameras:

| Id | Camera | Use |
|----|--------|-----|
| 1 | Front camera | The default. It looks at the user. Use it for a conference. |
| 0 | Main camera on the back | Use it when the back of the phone looks at the user. |
| 2 | Camera on the back with the largest sensor | Like id 0, with more pixels. |
| 3 | Camera on the back | Like id 0. |

Show the camera in use and the cameras of the phone:

    omalens camera

Use another camera:

    omalens camera 0

The command remembers the value in `~/.config/omalens/camera` and starts the
stream again.

The camera that looks at the user gives the correct picture. Look at the picture
with `omalens preview`. If the picture is dark or shows the room behind the
phone, the other side of the phone is in use. Then change the camera.

**The rotation can be different after a camera change.** Do section 6 again.

## 5. Use the microphone of the phone

The microphone of the phone is on by default. scrcpy sends the sound to the
computer, and the computer offers it as a microphone with the name **"OmaLens
Microphone"**.

| Command | Result |
|---------|--------|
| `omalens mic` | Show the state and the name of the microphone |
| `omalens mic on` | Use the microphone of the phone |
| `omalens mic off` | Do not use the microphone of the phone |

Select "OmaLens Microphone" as the microphone in the application. The command
does not change the default microphone of the computer.

The sound goes from the phone through the USB cable to the computer. The
computer needs the audio server PipeWire.

Notes:

- The variable `OMALENS_MIC_SOURCE` selects the source of the phone. The
  default is `mic`, the plain microphone. The sources for voice calls
  (`mic-voice-communication`, `voice-call`, `mic-voice-recognition`) add a noise
  gate: in a quiet room they gave digital silence. Use them only for a test.
- The microphone of the phone works together with the camera in one stream.
- The state is remembered in `~/.config/omalens/mic`.

## 6. Check the picture and set the rotation


The correct rotation of the picture depends on the position of the phone. A
phone that lies in landscape gives an upright picture with rotation 0.

Do these steps:

1. Start the camera stream.
2. Run `omalens preview`. A window shows the picture.
3. Look at the picture. Press q to close the window.
4. If the picture is not upright, run `omalens rotate 90` or
   `omalens rotate 270`.
5. Look at the picture again.

The command remembers the value in `~/.config/omalens/rotation`.
`omalens cycle-rotation` and a right click on the widget use the next value:
0, 90, 180, 270.

### Mirror

A mirror turns the picture like a mirror: the left hand of the user appears on
the left side of the picture.

    omalens mirror           show the state
    omalens mirror on        turn the mirror on
    omalens mirror off       turn the mirror off
    omalens mirror toggle    change the state

The state is remembered in `~/.config/omalens/mirror`. The command builds the
scrcpy value from the rotation and the mirror: rotation 270 with the mirror on
gives `flip270`.

**The mirror goes to the application too.** The other participants see the
mirrored picture as well. Many conference applications show your own picture as
a mirror without a change of the transmitted picture. Use the mirror of omalens
only when the transmitted picture must be mirrored, for example to show text in
the correct direction.

A terminal or a keybinding can also use the function of the bar widget:

    omarchy-shell kguenel.omalens mirror

Notes:

- The values 0 and 180 give a picture of 1920x1080. The values 90 and 270 give
  a picture of 1080x1920.
- A preview window of omalens opens again by itself after a change of the
  camera or of the rotation. The title of the window shows the values in use.
- A conference application keeps the picture that it opened at the start. After
  a change of the camera or of the rotation, select the camera again in the
  application.
- **Only one program can read the camera at a time.** Close the preview window
  (press q) before a conference application opens the camera. A preview window
  that stays open gives the message "the camera is busy" in the application.

## 7. Use the camera in a conference application

1. Start the camera stream.
2. Select "OmaLens Camera" in the application.
3. If a question about the camera appears, agree to it.

Note: the video device reports the capture ability only while the stream runs.
An application that opens the camera list before the stream starts shows no
camera. Start the stream first. If necessary, open the camera list of the
application again.

## 8. Problems and solutions

| Problem | Cause | Solution |
|---------|-------|----------|
| The camera is not in the camera list of the application. | The stream does not run. | Run `omalens start`. Open the camera list again. |
| `omalens: no phone in adb state 'device'` | The cable is loose. The phone waits for the permission for USB debugging. | Connect the cable again. Unlock the phone. Agree to the question about USB debugging. |
| The picture is not upright. | The rotation value does not agree with the position of the phone. | Do section 6. |
| `omalens: /dev/video10 is missing` | The kernel module is not loaded. This occurs after a kernel update. | Run `omalens-setup`. Type the password in the terminal window. |
| The picture is dark, or it shows the room behind the phone. | The camera on the other side of the phone is in use. | Use the camera that looks at you: `omalens camera 0` or `omalens camera 1`. |
| The picture does not change after `omalens rotate`, or after a camera change. | The application keeps the picture and the size that it opened at the start. | Select the camera again in the application. A omalens preview window opens again by itself. |
| The application has no sound from the phone. | The microphone is off, or the application uses another microphone. | Run `omalens mic` and select "OmaLens Microphone" in the application. |
| The application says that the camera is busy. | The omalens preview window has the camera open. Only one program can read the camera. | Close the preview window (press q) and select the camera again in the application. |
| `omalens camera 9` and the stream does not start. | The phone has no camera with this number. | Show the cameras with `omalens camera`. Set a correct number and run `omalens start`. |
| `adb devices` shows no phone and a restart does not help. | Two adb servers hold the interface of the phone. | The command `omalens start` repairs this. If the problem continues, run `adb kill-server` and `omalens start`. |
| The camera picture stops during a conference. | A USB error, or the phone stopped the camera. | Run `omalens start` again. |

## 9. Change the default values

Give these variables before the command:

| Variable | Default | Function |
|----------|---------|----------|
| `OMALENS_CAMERA_ID` | the saved value | The camera of the phone. See section 4. |
| `OMALENS_MIC_SOURCE` | `mic` | The audio source of the phone. See section 5. |
| `OMALENS_MIC_BITRATE` | `128K` | The data rate of the audio. |
| `OMALENS_MIRROR` | the saved value | The mirrored picture (`on` or `off`). |
| `OMALENS_SIZE` | `1920x1080` | The size of the picture. |
| `OMALENS_FPS` | `30` | The pictures per second. |
| `OMALENS_BITRATE` | `8M` | The data rate of the video. |
| `OMALENS_ROTATION` | the saved value | The rotation of the picture. |
| `OMALENS_DEVICE` | `/dev/video10` | The video device. |

Example:

    OMALENS_SIZE=1280x720 OMALENS_FPS=25 omalens start

Show the cameras of the phone:

    omalens camera

## 10. Update, remove, and another computer

The plugin is a git repository that Omarchy manages:

    omarchy plugin update kguenel.omalens    update the plugin
    omarchy plugin remove kguenel.omalens    remove the plugin

The command `omalens` lives in the plugin directory. For a terminal, add
this alias to `~/.bashrc`:

    alias omalens="$HOME/.config/omarchy/plugins/kguenel.omalens/bin/omalens"
    alias omalens-setup="$HOME/.config/omarchy/plugins/kguenel.omalens/bin/omalens-setup"

### Use the phone on another computer

On the other Omarchy computer, do these steps:

1. Install the packages:

       sudo pacman -S scrcpy android-tools android-udev v4l2loopback-dkms \
         v4l2loopback-utils ffmpeg pulseaudio-utils

2. Add the plugin:

       omarchy plugin add https://github.com/kguenel/omarchy-omalens
       omarchy restart shell

3. Build the kernel module. The command stops the camera stream and the
   preview window of the user first, then it asks for the password in a
   terminal window. It is safe to run again:

       ~/.config/omarchy/plugins/kguenel.omalens/bin/omalens-setup

4. Connect the phone with the USB cable.
5. Unlock the phone. Agree to the question about USB debugging. The phone asks
   this question for each new computer.
6. Click the camera icon in the bar, or run `omalens start`.
7. Look at the picture with `omalens preview` (section 6).

To remove everything from a computer, run `omarchy plugin remove
kguenel.omalens`, then, optionally:

    sudo rm /etc/modprobe.d/v4l2loopback.conf /etc/modules-load.d/v4l2loopback.conf
    sudo rmmod v4l2loopback
    rm -rf ~/.config/omalens

Notes:

- The device number can be different on the other computer, when another video
  device takes the same number. The command finds the device by the name
  "OmaLens Camera" in that case. Use `OMALENS_DEVICE` only for a special
  configuration.
- If the other computer uses Secure Boot, the module needs a signature. The
  setup script gives the steps.
- The rotation is not part of the plugin. Set it again with `omalens rotate`
  when the position of the phone changes.
- A kernel update removes the module for the new kernel until DKMS builds it
  again. Run `omalens-setup` if the virtual camera is missing.

## 11. Files

The plugin directory holds all files:

    ~/.config/omarchy/plugins/kguenel.omalens/
        manifest.json                   the plugin manifest
        OmaLens.qml                    the bar widget
        bin/omalens                    the control command
        bin/omalens-setup              the repair command
        setup-v4l2loopback.sh           the root part of the installation
        etc/modprobe.d/v4l2loopback.conf      the module options (source)
        etc/modules-load.d/v4l2loopback.conf  the load at boot (source)
        README.md                       the installation guide
        MANUAL.md                       this manual
        LICENSE                         the license (MIT)
        preview.png                     the bar screenshot

These files control the device and the stream:

    /etc/modprobe.d/v4l2loopback.conf          the module options
    /etc/modules-load.d/v4l2loopback.conf      the load at boot
    ~/.config/omalens/rotation                the saved rotation
    ~/.config/omalens/camera                  the saved camera
    ~/.config/omalens/mic                     the saved microphone state
    ~/.config/omalens/mirror                  the saved mirror state

## 12. Technical data

| Item | Value |
|------|-------|
| Phone | OnePlus 5 (ONEPLUS A5000), LineageOS 22, Android 15 |
| Camera | Rear camera, id 0 (default; `omalens camera` selects another) |
| Picture | 1920x1080, 30 pictures per second, H.264, 8 Mbit/s |
| Video device | v4l2loopback 0.15.4, `/dev/video10`, `exclusive_caps=1` |
| Connection | USB cable, adb |
| Microphone | The microphone of the phone, as the source "OmaLens Microphone" (Opus, 128 kbit/s) |
