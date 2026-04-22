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
    readonly property int languagesPageId: 1
    readonly property int themesPageId: 2
    readonly property int theoryPageId: 3
    readonly property int taskPageId: 4
    readonly property int navigateBack: 5
    //readonly property int progressPageId: 6
    property alias stack: content
    signal navigationRequest(int page_id, var properties)

    Rectangle {
        anchors.fill: parent
        color: "#eaf2ff"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 14

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 72
            radius: 18
            color: "#dce9ff"
            border.color: "#a9bddf"

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 10

                Repeater {
                    model: [
                        {id: languagesPageId, name: "Курсы"},
                        {id: themesPageId, name: "Уроки"},
                        {id: navigateBack, name: "Назад"}
                        //{id: progressPageId, name: "Прогресс"}
                    ]

                    Button {
                        Layout.fillWidth: true
                        text: modelData.name
                        font.pixelSize: 17
                        font.weight: Font.DemiBold

                        background: Rectangle {
                            radius: 12
                            color: parent.down ? "#4b84e6" : parent.hovered ? "#c0d7ff" : "#b2ccfb"
                            border.color: "#89a8d8"
                        }

                        Connections {
                            onClicked: navigationRequest(modelData.id, {})
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 18
            color: "#f3f8ff"
            border.color: "#a9bddf"
            clip: true

            StackView {
                id: content
                anchors.fill: parent
                anchors.margins: 10
            }
        }
    }
}
