import QtQuick

MainPageForm {
    stack.onCurrentItemChanged: {
        if (!stack.currentItem)
            return;

        if (stack.currentItem.langChosen) {
            stack.currentItem.langChosen.connect(function(lang_id) {
                stack.push("ThemesListPage.qml", {"lang_id": lang_id});
            });
        }

        if (stack.currentItem.themeChosen) {
            stack.currentItem.themeChosen.connect(function(theme_id) {
                stack.push("TheoryPage.qml", {"theme_id": theme_id});
            });
        }

        if (stack.currentItem.taskDemanded) {
            stack.currentItem.taskDemanded.connect(function(theme_id) {
                stack.push("TaskPage.qml", {"theme_id": theme_id});
            });
        }
    }
}
