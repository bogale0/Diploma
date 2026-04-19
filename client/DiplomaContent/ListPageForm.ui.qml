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

    GridView {
        id: gridView
        anchors.fill: parent
        anchors.margins: 14
        model: items
        clip: true
        cellWidth: Math.max(220, Math.floor((width - 10) / 2))
        cellHeight: 116

        delegate: Item {
            width: gridView.cellWidth
            height: gridView.cellHeight

            ItemDelegate {
                anchors.fill: parent
                anchors.margins: 5
                text: modelData.text

                background: Rectangle {
                    radius: 16
                    color: parent.down ? "#7c3aed" : parent.hovered ? "#202941" : "#141a28"
                    border.color: "#2d3752"
                }

                contentItem: ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 8

                    Text {
                        text: "#" + modelData.id
                        color: "#9eaefc"
                        font.pixelSize: 13
                    }

                    Text {
                        text: parent.parent.text
                        Layout.fillWidth: true
                        color: "#ecf1ff"
                        elide: Text.ElideRight
                        wrapMode: Text.WordWrap
                        maximumLineCount: 2
                        font.pixelSize: 18
                        font.weight: Font.DemiBold
                    }

                    Item {
                        Layout.fillHeight: true
                    }

                    Text {
                        text: "Открыть →"
                        color: "#c6d2ff"
                        font.pixelSize: 14
                    }
                }

                Connections {
                    onClicked: itemChosen(modelData.id)
                }
            }
        }

        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
        }
    }
}
