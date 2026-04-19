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
        color: "#f5f8ff"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 16
            color: "#ffffff"
            border.color: "#d7e3ff"

            ScrollView {
                id: scrollView
                anchors.fill: parent
                anchors.margins: 14
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                Text {
                    width: scrollView.availableWidth
                    wrapMode: Text.WordWrap
                    text: theoryContent
                    color: "#1d2945"
                    lineHeight: 1.3
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
                            color: parent.down ? "#4f46e5" : parent.hovered ? "#5f62d8" : "#4a56c8"
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
