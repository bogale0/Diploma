/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    property alias stack: content

    Rectangle {
        anchors.fill: parent
        color: "#06080f"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 14

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 72
            radius: 18
            color: "#10141f"
            border.color: "#272d3d"

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 10

                Repeater {
                    model: [
                        {name: "Языки", page: "LanguagesListPage.qml"},
                        {name: "Курсы", page: "ThemesListPage.qml"},
                        {name: "Прогресс", page: "ProgressPage.qml"}
                    ]

                    Button {
                        text: modelData.name
                        Layout.fillWidth: true

                        background: Rectangle {
                            radius: 12
                            color: parent.down ? "#7c3aed" : parent.hovered ? "#242c42" : "#1a2234"
                            border.color: "#303a55"
                        }

                        contentItem: Text {
                            text: parent.text
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: "#eaf0ff"
                            font.pixelSize: 17
                            font.weight: Font.DemiBold
                        }

                        Connections {
                            onClicked: content.replace(modelData.page)
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 18
            color: "#0d111b"
            border.color: "#272d3d"
            clip: true

            StackView {
                id: content
                anchors.fill: parent
                anchors.margins: 10
                initialItem: LanguagesListPage {}
            }
        }
    }
}
