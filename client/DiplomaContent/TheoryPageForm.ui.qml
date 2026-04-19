/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Diploma 1.0

Item {
    property var taskList
    property string theoryContent
    signal taskChosen(int id)

    Rectangle {
        anchors.fill: parent
        color: "#0d111b"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 16
            color: "#121826"
            border.color: "#2d3752"

            ScrollView {
                id: scrollView
                anchors.fill: parent
                anchors.margins: 14
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                Text {
                    width: scrollView.availableWidth
                    wrapMode: Text.WordWrap
                    text: theoryContent
                    color: "#eaf0ff"
                    lineHeight: 1.35
                    font.pixelSize: 20
                }
            }
        }

        Flickable {
            Layout.fillWidth: true
            Layout.preferredHeight: 64
            contentWidth: taskRow.width
            contentHeight: taskRow.height
            clip: true

            Row {
                id: taskRow
                spacing: 10

                Repeater {
                    model: taskList

                    Button {
                        text: "Задание " + modelData.id
                        width: 146
                        height: 48

                        background: Rectangle {
                            radius: 12
                            color: parent.down ? "#6d28d9" : parent.hovered ? "#5b34b8" : "#4c1d95"
                            border.color: "#6f49be"
                        }

                        contentItem: Text {
                            text: parent.text
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: "#ffffff"
                            font.pixelSize: 16
                            font.weight: Font.DemiBold
                        }

                        Connections {
                            onClicked: taskChosen(modelData.id)
                        }
                    }
                }
            }

            ScrollBar.horizontal: ScrollBar {
                policy: ScrollBar.AsNeeded
            }
        }
    }
}
