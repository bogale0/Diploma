import QtQuick
import Backend 1.0

ListPageForm {
    signal themeChosen(int id)
    required property int lang_id
    Component.onCompleted: Api.getThemes(lang_id)

    Connections {
        target: Api

        function onThemesReceived(themes) {
            items = themes
        }
    }

    Connections {
        function onItemChosen(id) {
            themeChosen(id)
        }
    }
}
