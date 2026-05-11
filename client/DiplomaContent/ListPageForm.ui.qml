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
    property bool detailedMode: false

    Rectangle {
        anchors.fill: parent
        color: "#f3f8ff"
    }

    GridView {
        id: gridView
        anchors.fill: parent
        anchors.margins: 18
        model: items
        clip: true
        cellWidth: detailedMode ? Math.max(320, Math.floor((width - 12) / 2)) : Math.max(280, Math.floor((width - 12) / 2))
        cellHeight: detailedMode ? 240 : 140

        delegate: Item {
            width: gridView.cellWidth
            height: gridView.cellHeight

            ItemDelegate {
                anchors.fill: parent
                anchors.margins: 5
                text: modelData.text

                background: Rectangle {
                    radius: 16
                    color: parent.down ? "#4b84e6" : parent.hovered ? "#c2d8ff" : "#d8e7ff"
                    border.color: "#9cb5db"
                }

                contentItem: RowLayout {
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 12

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: 6

                        Text {
                            text: modelData.text || ""
                            Layout.fillWidth: true
                            color: "#15335d"
                            elide: Text.ElideRight
                            wrapMode: Text.WordWrap
                            maximumLineCount: 2
                            font.pixelSize: 24
                            font.weight: Font.DemiBold
                        }

                        Text {
                            Layout.fillWidth: true
                            visible: detailedMode && modelData.description !== undefined && modelData.description !== null && modelData.description !== ""
                            text: modelData.description || ""
                            color: "#2f4f7a"
                            wrapMode: Text.WordWrap
                            maximumLineCount: 3
                            elide: Text.ElideRight
                            font.pixelSize: 21
                        }

                        Item {
                            Layout.fillHeight: true
                        }

                        Text {
                            text: "Открыть →"
                            color: "#395f96"
                            font.pixelSize: 18
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.preferredWidth: height

                        Image {
                            id: image
                            anchors.fill: parent
                            source: modelData.photo || ""
                            fillMode: Image.PreserveAspectFit
                            asynchronous: true
                            cache: true
                        }
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
