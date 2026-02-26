import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Diploma 1.0

RowLayout {
    required property int user_id
    anchors.fill: parent

    StackView {
        id: contentStack
        Layout.fillWidth: true
        Layout.fillHeight: true
        initialItem: "CourseListPage.qml"
    }

    Column {
        spacing: 10

        anchors {
            verticalCenter: parent.verticalCenter
        }

        Repeater {
            model: [
                {name: "Курсы", page: "CourseListPage.qml"},
                {name: "Прогресс", page: "ProgressPage.qml"},
                {name: "Профиль", page: "ProfilePage.qml"},
                {name: "Настройки", page: "SettingsPage.qml"}
            ]

            Button {
                text: modelData.name
                Layout.fillWidth: true

                Connections {
                    target: parent
                    onClicked: contentStack.replace(modelData.page)
                }
            }
        }
    }
}
