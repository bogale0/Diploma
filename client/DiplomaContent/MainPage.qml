import QtQuick
import Backend 1.0

MainPageForm {
    property int lang_id_cache: 0
    signal openAuthRequested()
    signal openTeacherRequested()

    function openProfile() {
        navigationRequest(profilePageId, null)
    }

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
                    if (!Api.authenticated) {
                        openAuthRequested();
                        return;
                    }
                    navigationRequest(taskPageId, {"task_id": task_id});
                });
                break;
            case taskPageId:
                page = stack.push("TaskPage.qml", {"task_id": properties.task_id});
                break;
            case profilePageId:
                if (!Api.authenticated) {
                    openAuthRequested();
                    return;
                }
                page = stack.push("ProfilePage.qml");
                page.loggedOut.connect(function() { stack.clear(); navigationRequest(languagesPageId, null); });
                break;
            case teacherPageId:
                if (Api.userRole !== "teacher") {
                    openAuthRequested();
                    return;
                }
                openTeacherRequested();
                break;
            case navigateBack:
                stack.pop();
                break;
            }
        }
    }
}
