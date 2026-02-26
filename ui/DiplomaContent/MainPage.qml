import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Diploma 1.0

ColumnLayout {
    required property int user_id
    property bool isTaskSolved: false

    Row {
        spacing: 10

        Repeater {
            model: [
                {name: "Языки", page: "LanguagesListPage.qml"},
                {name: "Курсы", page: "CourseListPage.qml"},
                {name: "Прогресс", page: "ProgressPage.qml", params: {"isTaskSolved": isTaskSolved}},
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
        initialItem: LanguagesListPage {}

        onCurrentItemChanged: {
            if (!currentItem)
                return;

            if (currentItem.langChosen) {
                currentItem.langChosen.connect(function(lang_id) {
                    if (lang_id === 1)
                        content.push("CourseListPage.qml");
                    else
                        currentItem.errText = "Курс находится в разработке"
                });
            }

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

            if (currentItem.taskSolved) {
                currentItem.taskSolved.connect(function() {
                    isTaskSolved = true;
                });
            }
        }
    }
}
