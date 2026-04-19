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
        color: "#0d111b"
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
                color: parent.down ? "#7c3aed" : parent.hovered ? "#202941" : "#141a28"
                border.color: "#2d3752"
            }

            contentItem: RowLayout {
                anchors.fill: parent
                anchors.margins: 14

                Text {
                    text: parent.parent.text
                    Layout.fillWidth: true
                    color: "#ecf1ff"
                    elide: Text.ElideRight
                    font.pixelSize: 18
                    font.weight: Font.DemiBold
                    verticalAlignment: Text.AlignVCenter
                }

                Rectangle {
                    Layout.preferredWidth: 36
                    Layout.preferredHeight: 36
                    radius: 18
                    color: "#1c2436"

                    Text {
                        anchors.centerIn: parent
                        text: "➜"
                        color: "#9eaefc"
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
