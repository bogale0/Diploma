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
    required property int user_id
    property alias stack: contentStack

    RowLayout {
        anchors.fill: parent

        Rectangle {
            width: 220
            color: "#2c3e50"

            Column {
                anchors.fill: parent
                spacing: 5

                Repeater {
                    model: [
                        {name: "Курсы", page: "CourseListPage.qml"},
                        {name: "Прогресс", page: "ProgressPage.qml"},
                        {name: "Профиль", page: "ProfilePage.qml"},
                        {name: "Настройки", page: "SettingsPage.qml"}
                    ]

                    Button {
                        id: d
                        text: modelData.name
                        Layout.fillWidth: true

                        /*onClicked: {
                            contentStack.replace(modelData.page)
                        }*/
                    }
                }
            }
        }

        StackView {
            id: contentStack
            Layout.fillWidth: true
            Layout.fillHeight: true
            initialItem: Authorization {}
        }
    }
}
