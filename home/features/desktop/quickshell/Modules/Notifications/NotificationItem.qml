pragma ComponentBehavior: Bound

import qs.Components
import qs.Services
import qs.Config
import qs.Utils
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

StyledRect {
    id: root

    required property Notifs.Notif modelData
    readonly property bool hasImage: modelData.image.length > 0
    readonly property bool hasAppIcon: modelData.appIcon.length > 0
    readonly property int nonAnimHeight: summary.implicitHeight + (root.expanded ? appName.height + body.height + actions.height + actions.anchors.topMargin : bodyPreview.height) + inner.anchors.margins * 2
    property bool expanded

    color: root.modelData.urgency === NotificationUrgency.Critical ? Config.colours.backgroundDark: Config.colours.backgroundLight
    radius: Config.style.roundingNormal
    implicitWidth: Config.notification.sizes.width
    implicitHeight: inner.implicitHeight

    x: Config.notification.sizes.width
    Component.onCompleted: x = 0

    Behavior on x {
        NumberAnimation {
            duration: Config.animation.animDurations.normal
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Config.animation.animCurves.emphasizedDecel
        }
    }

    RetainableLock {
        object: root.modelData.notification
        locked: true
    }

    MouseArea {
        property int startY

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: root.expanded && body.hoveredLink ? Qt.PointingHandCursor : pressed ? Qt.ClosedHandCursor : undefined
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
        preventStealing: true

        onEntered: root.modelData.timer.stop()
        onExited: {
            if (!pressed)
                root.modelData.timer.start();
        }

        drag.target: parent
        drag.axis: Drag.XAxis

        onPressed: event => {
            root.modelData.timer.stop();
            startY = event.y;
            if (event.button === Qt.MiddleButton)
                root.modelData.notification.dismiss();
        }
        onReleased: event => {
            if (!containsMouse)
                root.modelData.timer.start();

            if (Math.abs(root.x) < Config.notification.sizes.width * Config.notification.clearThreshold)
                root.x = 0;
            else
                root.modelData.notification.dismiss(); // TODO: change back to popup when notif dock impled
        }
        onPositionChanged: event => {
            if (pressed) {
                const diffY = event.y - startY;
                if (Math.abs(diffY) > Config.notification.expandThreshold)
                    root.expanded = diffY > 0;
            }
        }
        onClicked: event => {
            if (!Config.notification.actionOnClick || event.button !== Qt.LeftButton)
                return;

            const actions = root.modelData.actions;
            if (actions?.length === 1)
                actions[0].invoke();
        }

        Item {
            id: inner

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: Config.style.paddingNormal

            implicitHeight: root.nonAnimHeight

            Behavior on implicitHeight {
                Anim {
                    duration: Config.animation.animDurations.expressiveDefaultSpatial
                    easing.bezierCurve: Config.animation.animCurves.expressiveDefaultSpatial
                }
            }

            Loader {
                id: image

                active: root.hasImage
                asynchronous: true

                anchors.left: parent.left
                anchors.top: parent.top
                width: Config.notification.sizes.image
                height: Config.notification.sizes.image

                visible: root.hasImage || root.hasAppIcon

                sourceComponent: ClippingRectangle {
                    radius: Config.style.roundingFull
                    implicitWidth: Config.notification.sizes.image
                    implicitHeight: Config.notification.sizes.image

                    Image {
                        anchors.fill: parent
                        source: Qt.resolvedUrl(root.modelData.image)
                        fillMode: Image.PreserveAspectCrop
                        cache: false
                        asynchronous: true
                    }
                }
            }

            Loader {
                id: appIcon

                active: root.hasAppIcon || !root.hasImage
                asynchronous: true

                anchors.horizontalCenter: root.hasImage ? undefined : image.horizontalCenter
                anchors.verticalCenter: root.hasImage ? undefined : image.verticalCenter
                anchors.right: root.hasImage ? image.right : undefined
                anchors.bottom: root.hasImage ? image.bottom : undefined

                sourceComponent: StyledRect {
                    radius: Config.style.roundingFull
                    color: root.modelData.urgency === NotificationUrgency.Critical ? Config.colours.error : root.modelData.urgency === NotificationUrgency.Low ? Config.colours.backgroundLight : Config.colours.backgroundDark
                    implicitWidth: root.hasImage ? Config.notification.sizes.badge : Config.notification.sizes.image
                    implicitHeight: root.hasImage ? Config.notification.sizes.badge : Config.notification.sizes.image

                    Loader {
                        id: icon

                        active: root.hasAppIcon
                        asynchronous: true

                        anchors.centerIn: parent

                        width: Math.round(parent.width * 0.6)
                        height: Math.round(parent.width * 0.6)

                        sourceComponent: IconImage {
                            anchors.fill: parent
                            source: Quickshell.iconPath(root.modelData.appIcon)
                            asynchronous: true

                            layer.enabled: root.modelData.appIcon.endsWith("symbolic")
                            layer.effect: Colouriser {
                                colorizationColor: root.modelData.urgency === NotificationUrgency.Critical ? Config.colours.error : root.modelData.urgency === NotificationUrgency.Low ? Config.colours.backgroundLight : Config.colours.backgroundDark
                            }
                        }
                    }

                    Loader {
                        active: !root.hasAppIcon
                        asynchronous: true
                        anchors.centerIn: parent
                        anchors.horizontalCenterOffset: -Config.style.fontSizeLarge * 0.02
                        anchors.verticalCenterOffset: Config.style.fontSizeLarge * 0.02

                        sourceComponent: Icon {
                            text: Icons.getNotifIcon(root.modelData.summary.toLowerCase(), root.modelData.urgency)

                            color: root.modelData.urgency === NotificationUrgency.Critical ? Config.colours.error : root.modelData.urgency === NotificationUrgency.Low ? Config.colours.backgroundLight : Config.colours.backgroundDark
                            font.pixelSize: Config.style.fontSizeLarge
                        }
                    }
                }
            }

            StyledText {
                id: appName

                anchors.top: parent.top
                anchors.left: image.right
                anchors.leftMargin: Config.style.spacingSmaller

                animate: true
                text: appNameMetrics.elidedText
                maximumLineCount: 1
                color: Config.colours.backgroundLight
                font.pixelSize: Config.style.fontSizeSmall

                opacity: root.expanded ? 1 : 0

                Behavior on opacity {
                    Anim {}
                }
            }

            TextMetrics {
                id: appNameMetrics

                text: root.modelData.appName
                font.family: appName.font.family
                font.pointSize: appName.font.pointSize
                elide: Text.ElideRight
                elideWidth: expandBtn.x - time.width - timeSep.width - summary.x - Config.style.spacingSmall * 3
            }

            StyledText {
                id: summary

                anchors.top: parent.top
                anchors.left: image.right
                anchors.leftMargin: Config.style.spacingSmaller

                animate: true
                text: summaryMetrics.elidedText
                maximumLineCount: 1
                height: implicitHeight

                states: State {
                    name: "expanded"
                    when: root.expanded

                    PropertyChanges {
                        summary.maximumLineCount: undefined
                    }

                    AnchorChanges {
                        target: summary
                        anchors.top: appName.bottom
                    }
                }

                transitions: Transition {
                    PropertyAction {
                        target: summary
                        property: "maximumLineCount"
                    }
                    AnchorAnimation {
                        duration: Config.animation.animDurations.normal
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Config.animation.animCurves.standard
                    }
                }

                Behavior on height {
                    Anim {}
                }
            }

            TextMetrics {
                id: summaryMetrics

                text: root.modelData.summary
                font.family: summary.font.family
                font.pointSize: summary.font.pointSize
                elide: Text.ElideRight
                elideWidth: expandBtn.x - time.width - timeSep.width - summary.x - Config.style.spacingSmall * 3
            }

            StyledText {
                id: timeSep

                anchors.top: parent.top
                anchors.left: summary.right
                anchors.leftMargin: Config.style.spacingSmall

                text: "•"
                color: Config.colours.backgroundLight
                font.pixelSize: Config.style.fontSizeSmall

                states: State {
                    name: "expanded"
                    when: root.expanded

                    AnchorChanges {
                        target: timeSep
                        anchors.left: appName.right
                    }
                }

                transitions: Transition {
                    AnchorAnimation {
                        duration: Config.animation.animDurations.normal
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Config.animation.animCurves.standard
                    }
                }
            }

            StyledText {
                id: time

                anchors.top: parent.top
                anchors.left: timeSep.right
                anchors.leftMargin: Config.style.spacingSmall

                animate: true
                horizontalAlignment: Text.AlignLeft
                text: root.modelData.timeStr
                color: Config.colours.backgroundLight
                font.pixelSize: Config.style.fontSizeSmall
            }

            Item {
                id: expandBtn

                anchors.right: parent.right
                anchors.top: parent.top

                implicitWidth: expandIcon.height
                implicitHeight: expandIcon.height

                StateLayer {
                    radius: Config.style.roundingFull
                    color: root.modelData.urgency === NotificationUrgency.Critical ? Config.colours.backgroundLightContainer : Config.colours.backgroundLight

                    function onClicked() {
                        root.expanded = !root.expanded;
                    }
                }

                Icon {
                    id: expandIcon

                    anchors.centerIn: parent

                    animate: true
                    text: root.expanded ? "expand_less" : "expand_more"
                    font.pixelSize: Config.style.fontSizeNormal
                }
            }

            StyledText {
                id: bodyPreview

                anchors.left: summary.left
                anchors.right: expandBtn.left
                anchors.top: summary.bottom
                anchors.rightMargin: Config.style.spacingSmall

                animate: true
                textFormat: Text.MarkdownText
                text: bodyPreviewMetrics.elidedText
                color: Config.colours.backgroundLight
                font.pixelSize: Config.style.fontSizeSmall

                opacity: root.expanded ? 0 : 1

                Behavior on opacity {
                    Anim {}
                }
            }

            TextMetrics {
                id: bodyPreviewMetrics

                text: root.modelData.body
                font.family: bodyPreview.font.family
                font.pointSize: bodyPreview.font.pointSize
                elide: Text.ElideRight
                elideWidth: bodyPreview.width
            }

            StyledText {
                id: body

                anchors.left: summary.left
                anchors.right: expandBtn.left
                anchors.top: summary.bottom
                anchors.rightMargin: Config.style.spacingSmall

                animate: true
                textFormat: Text.MarkdownText
                text: root.modelData.body
                color: Config.colours.backgroundLight
                font.pixelSize: Config.style.fontSizeSmall
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                height: text ? implicitHeight : 0

                onLinkActivated: link => {
                    if (!root.expanded)
                        return;

                    Quickshell.execDetached(["app2unit", "-O", "--", link]);
                    root.modelData.notification.dismiss(); // TODO: change back to popup when notif dock impled
                }

                opacity: root.expanded ? 1 : 0

                Behavior on opacity {
                    Anim {}
                }
            }

            RowLayout {
                id: actions

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: body.bottom
                anchors.topMargin: Config.style.spacingSmall

                spacing: Config.style.spacingSmaller

                opacity: root.expanded ? 1 : 0

                Behavior on opacity {
                    Anim {}
                }

                Action {
                    modelData: QtObject {
                        readonly property string text: qsTr("Close")
                        function invoke(): void {
                            root.modelData.notification.dismiss();
                        }
                    }
                }

                Repeater {
                    model: root.modelData.actions

                    delegate: Component {
                        Action {}
                    }
                }
            }
        }

        component Action: StyledRect {
            id: action

            required property var modelData

            radius: Config.style.roundingFull
            color: root.modelData.urgency === NotificationUrgency.Critical ? Config.colours.textSecondary : Config.colours.backgroundLight

            Layout.preferredWidth: actionText.width + Config.style.paddingNormal * 2
            Layout.preferredHeight: actionText.height + Config.style.paddingSmall * 2
            implicitWidth: actionText.width + Config.style.paddingNormal * 2
            implicitHeight: actionText.height + Config.style.paddingSmall * 2

            StateLayer {
                radius: Config.style.roundingFull
                color: root.modelData.urgency === NotificationUrgency.Critical ? Config.colours.backgroundLight : Config.colours.backgroundLight

                function onClicked(): void {
                    action.modelData.invoke();
                }
            }

            StyledText {
                id: actionText

                anchors.centerIn: parent
                text: actionTextMetrics.elidedText
                color: root.modelData.urgency === NotificationUrgency.Critical ? Config.colours.textSecondary : Config.colours.textPrimary
                font.pixelSize: Config.style.fontSizeSmall
            }

            TextMetrics {
                id: actionTextMetrics

                text: action.modelData.text
                font.family: actionText.font.family
                font.pointSize: actionText.font.pointSize
                elide: Text.ElideRight
                elideWidth: {
                    const numActions = root.modelData.actions.length + 1;
                    return (inner.width - actions.spacing * (numActions - 1)) / numActions - Config.style.paddingNormal * 2;
                }
            }
        }
    }

    component Anim: NumberAnimation {
        duration: Config.animation.animDurations.normal
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Config.animation.animCurves.standard
    }
}
