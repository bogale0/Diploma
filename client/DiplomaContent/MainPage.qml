import QtQuick

MainPageForm {
    property int lang_id_cache: 0

    Connections {
        Component.onCompleted: navigationRequest(languagesPageId, null)

        function onNavigationRequest(page_id, properties) {
            var page;
            switch (page_id) {
            case languagesPageId:
                page = stack.push("LanguagesListPage.qml");
                page.langChosen.connect(function(lang_id) {
                    lang_id_cache = lang_id;
                    navigationRequest(themesPageId, null);
                });
                break;
            case themesPageId:
                page = stack.push("ThemesListPage.qml", {"lang_id": lang_id_cache});
                page.themeChosen.connect(function(theme_id) {
                    navigationRequest(theoryPageId, {"theme_id": theme_id});
                });
                break;
            case theoryPageId:
                page = stack.push("TheoryPage.qml", {"theme_id": properties.theme_id});
                page.taskDemanded.connect(function(task_id) {
                    navigationRequest(taskPageId, {"task_id": task_id});
                });
                break;
            case taskPageId:
                page = stack.push("TaskPage.qml", {"task_id": properties.task_id});
                /*page.taskSolved.connect(function(task_id) {
                    navigationRequest(taskPageId, {"task_id": task_id});
                });*/
                break;
            /*case progressPageId:
                page = stack.push("ProgressPage.qml");
                break;*/
            }
        }
    }
}
