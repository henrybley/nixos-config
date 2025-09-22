pragma ComponentBehavior: Bound

import qs.Services
import qs.Config
//import qs.modules.windowinfo
import qs.Modules.Detachedcontent
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick

Item {
    id: root

    required property ShellScreen screen

    readonly property real nonAnimWidth: x > 0 || hasCurrent ? children.find(c => c.shouldBeActive)?.implicitWidth ?? content.implicitWidth : 0
    readonly property real nonAnimHeight: children.find(c => c.shouldBeActive)?.implicitHeight ?? content.implicitHeight

    property string currentName
    property real currentCenter
    property bool hasCurrent

    property string detachedMode
    property string queuedMode
    readonly property bool isDetached: detachedMode.length > 0

    property int animLength: Config.animation.animDurations.normal
    property list<real> animCurve: Config.animation.animCurves.emphasized

    function detach(mode: string): void {
        animLength = Config.animation.animDurations.large;
        if (mode === "winfo") {
            detachedMode = mode;
        } else {
            detachedMode = "any";
            queuedMode = mode;
        }
        focus = true;
    }

    function close(): void {
        hasCurrent = false;
        animCurve = Config.animation.animCurves.emphasizedAccel;
        animLength = Config.animation.animDurations.normal;
        detachedMode = "";
    }

    visible: width > 0 && height > 0
    clip: true

    implicitWidth: nonAnimWidth
    implicitHeight: nonAnimHeight

    Keys.onEscapePressed: close()

    HyprlandFocusGrab {
        active: root.isDetached
        windows: [QsWindow.window]
        onCleared: root.close()
    }

    Binding {
        when: root.isDetached

        target: QsWindow.window
        property: "WlrLayershell.keyboardFocus"
        value: WlrKeyboardFocus.OnDemand
    }

    Comp {
        id: content

        shouldBeActive: !root.detachedMode
        asynchronous: true
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        sourceComponent: Content {
            wrapper: root
        }
    }

    /*Comp {
        shouldBeActive: root.detachedMode === "winfo"
        asynchronous: true
        anchors.centerIn: parent

        sourceComponent: WindowInfo {
            screen: root.screen
            client: Hyprland.activeToplevel
        }
    }*/

    Comp {
        id: detachedContent

        shouldBeActive: root.detachedMode === "any"
        asynchronous: true
        anchors.centerIn: parent

        sourceComponent: DetachedContent {
            screen: root.screen
            active: root.queuedMode
        }
    }

    Behavior on x {
        Anim {
            duration: root.animLength
            easing.bezierCurve: root.animCurve
        }
    }

    Behavior on y {
        enabled: root.implicitWidth > 0

        Anim {
            duration: root.animLength
            easing.bezierCurve: root.animCurve
        }
    }

    Behavior on implicitWidth {
        Anim {
            duration: root.animLength
            easing.bezierCurve: root.animCurve
        }
    }

    Behavior on implicitHeight {
        enabled: root.implicitWidth > 0

        Anim {
            duration: root.animLength
            easing.bezierCurve: root.animCurve
        }
    }

    component Comp: Loader {
        id: comp

        property bool shouldBeActive

        asynchronous: true
        active: false
        opacity: 0

        states: State {
            name: "active"
            when: comp.shouldBeActive

            PropertyChanges {
                comp.opacity: 1
                comp.active: true
            }
        }

        transitions: [
            Transition {
                from: ""
                to: "active"

                SequentialAnimation {
                    PropertyAction {
                        property: "active"
                    }
                    Anim {
                        property: "opacity"
                        easing.bezierCurve: Config.animation.animCurves.standard
                    }
                }
            },
            Transition {
                from: "active"
                to: ""

                SequentialAnimation {
                    Anim {
                        property: "opacity"
                        easing.bezierCurve: Config.animation.animCurves.standard
                    }
                    PropertyAction {
                        property: "active"
                    }
                }
            }
        ]
    }

    component Anim: NumberAnimation {
        duration: Config.animation.animDurations.normal
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Config.animation.animCurves.emphasized
    }
}
