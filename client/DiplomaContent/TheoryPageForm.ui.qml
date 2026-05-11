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
        color: "#f3f8ff"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 14

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 16
            color: "#e1edff"
            border.color: "#9cb5db"

            ScrollView {
                id: scrollView
                anchors.fill: parent
                anchors.margins: 14
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                Text {
                    width: scrollView.availableWidth
                    wrapMode: Text.WordWrap
                    text: theoryContent
                    color: "#17325d"
                    lineHeight: 1.35
                    font.pixelSize: 26
                }
            }
        }

        Flickable {
            Layout.fillWidth: true
            Layout.preferredHeight: 76
            contentWidth: taskRow.width
            contentHeight: taskRow.height
            clip: true

            Row {
                id: taskRow
                spacing: 10
                property int counter: 1

                Repeater {
                    model: taskList

                    Button {
                        text: "Задание " + taskRow.counter++
                        width: 180
                        height: 58

                        background: Rectangle {
                            radius: 12
                            color: parent.down ? "#4f8ef7" : parent.hovered ? "#3f7ee8" : "#316ad1"
                            border.color: "#7ea5df"
                        }

                        contentItem: Text {
                            text: parent.text
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: "#f8fbff"
                            font.pixelSize: 20
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
