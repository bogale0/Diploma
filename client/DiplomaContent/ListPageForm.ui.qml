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
        anchors.margins: 14
        model: items
        clip: true
        cellWidth: detailedMode ? Math.max(260, Math.floor((width - 10) / 2)) : Math.max(220, Math.floor((width - 10) / 2))
        cellHeight: detailedMode ? 200 : 116

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
                            text: "#" + modelData.id
                            color: "#456ca8"
                            font.pixelSize: 13
                        }

                        Text {
                            text: modelData.text || ""
                            Layout.fillWidth: true
                            color: "#15335d"
                            elide: Text.ElideRight
                            wrapMode: Text.WordWrap
                            maximumLineCount: 2
                            font.pixelSize: 18
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
                            font.pixelSize: 16
                        }

                        Item {
                            Layout.fillHeight: true
                        }

                        Text {
                            text: "Открыть →"
                            color: "#395f96"
                            font.pixelSize: 14
                        }
                    }

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.preferredWidth: image.sourceSize.width / image.sourceSize.height * height
                        visible: detailedMode && modelData.photo !== undefined && modelData.photo !== null && modelData.photo !== ""
                        radius: 12
                        color: "#c9dbf7"
                        border.color: "#9cb5db"
                        clip: true

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
