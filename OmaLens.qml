import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

// Bar widget for omalens: the OnePlus 5 camera as a webcam.
//
//   left click    start or stop the camera stream
//   right click   use the next picture rotation
//   middle click  show the picture in a preview window
//   wheel         turn the picture (up: next, down: previous rotation)
//
// The widget shows the state only. All work is done by the omalens command
// that ships in the plugin directory (bin/omalens), so the state is also
// correct when the stream starts from a terminal.
BarWidget {
  id: root
  moduleName: "kguenel.omalens"

  // The control command next to this file, in the plugin directory. The
  // plugin is self-contained: no other files are installed.
  readonly property string cli: Qt.resolvedUrl("bin/omalens").toString().replace(/^file:\/\//, "")

  // True while the camera stream runs.
  property bool running: false
  // True for a short time after an action. The stream then starts or stops,
  // and the widget must poll more often until the state is correct.
  property bool settling: false

  visible: true
  // The bar sizes the widget slot from these two values. Without them the
  // slot is 0x0 and the widget stays invisible.
  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  function refresh() {
    if (!statusProc.running)
      statusProc.running = true
  }

  function act(verb) {
    if (root.bar)
      root.bar.run("'" + root.cli + "' " + verb)
    root.settling = true
    settleDone.restart()
    refreshTimer.restart()
  }

  function toggle() {
    act(root.running ? "stop" : "start")
  }

  function rotate() {
    act("cycle-rotation")
  }

  function preview() {
    act("preview")
  }

  // A keybinding or a terminal can use this function:
  //   omarchy-shell kguenel.omalens mirror
  function mirror() {
    act("mirror toggle")
  }

  // The wheel turns the picture without a click. This also works when a
  // problem with the mouse buttons prevents a click.
  function wheelTurn(delta) {
    act(delta > 0 ? "cycle-rotation" : "prev-rotation")
  }

  Component.onCompleted: refresh()

  // The same actions as the clicks, for a terminal or a keybinding:
  //   omarchy-shell kguenel.omalens toggle
  IpcHandler {
    target: "kguenel.omalens"

    function toggle(): void {
      root.toggle()
    }
    function start(): void {
      root.act("start")
    }
    function stop(): void {
      root.act("stop")
    }
    function rotate(): void {
      root.act("cycle-rotation")
    }
    function preview(): void {
      root.act("preview")
    }
    function mirror(): void {
      root.mirror()
    }
    function refresh(): string {
      root.refresh()
      return root.running ? "running" : "stopped"
    }
    function status(): string {
      return root.running ? "running" : "stopped"
    }
  }

  // The exit status of "omalens is-running" is the state.
  Process {
    id: statusProc
    command: [root.cli, "is-running"]
    onExited: function(exitCode) {
      root.running = exitCode === 0
    }
  }

  Timer {
    id: refreshTimer
    interval: root.settling ? 1000 : 5000
    running: true
    repeat: true
    onTriggered: root.refresh()
  }

  Timer {
    id: settleDone
    interval: 12000
    onTriggered: root.settling = false
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "󰄀"
    active: root.running
    tooltipText: root.running ? "OmaLens streams the phone camera. Left: stop, right: rotate, wheel: rotate, middle: preview" : "OmaLens is off. Left: start, right: rotate, wheel: rotate, middle: preview"
    onPressed: function(b) {
      if (b === Qt.MiddleButton)
        root.preview()
      else if (b === Qt.RightButton)
        root.rotate()
      else
        root.toggle()
    }
    onWheelMoved: function(delta) {
      root.wheelTurn(delta)
    }
  }
}
