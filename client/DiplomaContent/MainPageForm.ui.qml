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
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#0b1220"
            }
            GradientStop {
                position: 1
                color: "#161f36"
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 14

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 72
            radius: 18
            color: "#1d2945"
            border.color: "#2a3a62"

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
                            color: parent.down ? "#4f46e5" : parent.hovered ? "#303f67" : "#263556"
                            border.color: "#3d4f79"
                        }

                        contentItem: Text {
                            text: parent.text
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: "#e8f0ff"
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
            color: "#f8faff"
            border.color: "#d9e4ff"
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
