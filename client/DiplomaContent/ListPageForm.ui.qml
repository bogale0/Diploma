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
    property var items
    signal itemChosen(int id)

    Rectangle {
        anchors.fill: parent
        color: "#f5f8ff"
    }

    ListView {
        anchors.fill: parent
        anchors.margins: 14
        model: items
        spacing: 10
        clip: true

        delegate: ItemDelegate {
            width: ListView.view.width
            height: 72
            text: modelData.text

            background: Rectangle {
                radius: 14
                color: parent.down ? "#dbe8ff" : parent.hovered ? "#edf3ff" : "#ffffff"
                border.color: "#d7e3ff"
            }

            contentItem: RowLayout {
                anchors.fill: parent
                anchors.margins: 14

                Text {
                    text: parent.parent.text
                    Layout.fillWidth: true
                    color: "#1b2740"
                    elide: Text.ElideRight
                    font.pixelSize: 18
                    font.weight: Font.DemiBold
                    verticalAlignment: Text.AlignVCenter
                }

                Rectangle {
                    Layout.preferredWidth: 36
                    Layout.preferredHeight: 36
                    radius: 18
                    color: "#e9efff"

                    Text {
                        anchors.centerIn: parent
                        text: "➜"
                        color: "#3d56d6"
                        font.pixelSize: 18
                    }
                }
            }

            Connections {
                onClicked: itemChosen(modelData.id)
            }
        }

        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
        }
    }
}
