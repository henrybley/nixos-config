import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.Components
import qs.Config
import Quickshell.Wayland

PanelWithOverlay {
    id: calendarOverlay

    Rectangle {
        color: Config.colours.backgroundPrimary
        radius: 12
        border.color: Config.colours.backgroundLight
        border.width: 1
        width: 340
        height: 380
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 4
        anchors.rightMargin: 4

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            // Month/Year header with navigation
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                IconButton {
                    icon: "chevron_left"
                    onClicked: {
                        let newDate = new Date(calendar.year, calendar.month - 1, 1);
                        calendar.year = newDate.getFullYear();
                        calendar.month = newDate.getMonth();
                    }
                }

                Text {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    text: calendar.title
                    color: Config.colours.textPrimary
                    opacity: 0.7
                    font.pixelSize: 13
                    font.family: Config.style.fontFamily
                    font.bold: true
                }

                IconButton {
                    icon: "chevron_right"
                    onClicked: {
                        let newDate = new Date(calendar.year, calendar.month + 1, 1);
                        calendar.year = newDate.getFullYear();
                        calendar.month = newDate.getMonth();
                    }
                }
            }

            DayOfWeekRow {
                Layout.fillWidth: true
                spacing: 0
                Layout.leftMargin: 8  // Align with grid
                Layout.rightMargin: 8
                delegate: Text {
                    text: shortName
                    color: Config.colours.textPrimary
                    opacity: 0.8
                    font.pixelSize: 13
                    font.family: Config.style.fontFamily
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    width: 32
                }
            }

            MonthGrid {
                id: calendar
                Layout.fillWidth: true
                Layout.leftMargin: 8
                Layout.rightMargin: 8
                spacing: 0
                month: DateTime.date.getMonth()
                year: DateTime.date.getFullYear()

                delegate: Rectangle {
                    width: 32
                    height: 32
                    radius: 8
                    color: {
                        if (model.today)
                            return Config.colours.accentPrimary;
                        if (mouseArea2.containsMouse)
                            return Config.colours.backgroundLight;
                        return "transparent";
                    }

                    Text {
                        anchors.centerIn: parent
                        text: model.day
                        color: model.today ? Config.colours.onAccent : Config.colours.textPrimary
                        opacity: model.month === calendar.month ? (mouseArea2.containsMouse ? 1.0 : 0.7) : 0.3
                        font.pixelSize: 13
                        font.family: Config.style.fontFamily
                        font.bold: model.today ? true : false
                    }

                    MouseArea {
                        id: mouseArea2
                        anchors.fill: parent
                        hoverEnabled: true
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 150
                        }
                    }
                }
            }
        }
    }
}
