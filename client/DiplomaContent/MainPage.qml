import QtQuick

MainPageForm {
    stack.onCurrentItemChanged: {
        if (!currentItem)
            return;

        if (currentItem.langChosen) {
            currentItem.langChosen.connect(function(lang_id) {
                stack.push("CourseListPage.qml");
            });
        }

        if (currentItem.themeChosen) {
            currentItem.themeChosen.connect(function(theme_id) {
                stack.push("TheoryPage.qml", {"theme_id": theme_id});
            });
        }

        if (currentItem.taskDemanded) {
            currentItem.taskDemanded.connect(function(theme_id) {
                stack.push("TaskPage.qml", {"theme_id": theme_id, "user_id": user_id});
            });
        }
    }
}
