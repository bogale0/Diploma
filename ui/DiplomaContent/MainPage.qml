import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Diploma 1.0

ColumnLayout {
    required property int user_id

    Row {
        spacing: 10

        Repeater {
            model: [
                {name: "Курсы", page: "CourseListPage.qml", params: {}},
                {name: "Прогресс", page: "ProgressPage.qml", params: {"user_id": user_id}},
                {name: "Профиль", page: "ProfilePage.qml", params: {}},
                {name: "Настройки", page: "SettingsPage.qml", params: {}}
            ]

            Button {
                text: modelData.name
                Layout.fillWidth: true
                onClicked: content.replace(modelData.page, modelData.params || {})
            }
        }
    }

    StackView {
        id: content
        Layout.fillWidth: true
        Layout.fillHeight: true
        initialItem: "CourseListPage.qml"

        onCurrentItemChanged: {
            if (!currentItem)
                return;

            if (currentItem.themeChosen) {
                currentItem.themeChosen.connect(function(theme_id) {
                    content.push("TheoryPage.qml", {"theme_id": theme_id});
                });
            }

            if (currentItem.taskDemanded) {
                currentItem.taskDemanded.connect(function(theme_id) {
                    content.push("TaskPage.qml", {"theme_id": theme_id, "user_id": user_id});
                });
            }
        }
    }
}
