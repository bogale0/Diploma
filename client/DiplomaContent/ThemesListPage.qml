import QtQuick
import Backend 1.0

ListPageForm {
    detailedMode: true
    signal themeChosen(int id)
    required property int lang_id
    Component.onCompleted: Api.getThemes(lang_id)

    Connections {
        target: Api

        function onThemesReceived(themes) {
            items = themes.map(function(theme, index) {
                var enrichedTheme = Object.assign({}, theme)
                enrichedTheme.description = "Кратко: в этом уроке разбираются ключевые идеи темы \""
                        + (theme.text || "")
                        + "\", практические шаги и типичные ошибки. В конце вас ждёт закрепляющее задание."
                if (index % 2 === 0) {
                    enrichedTheme.description += " Подойдёт для поэтапного изучения с примерами."
                }
                return enrichedTheme
            })
        }
    }

    Connections {
        function onItemChosen(id) {
            themeChosen(id)
        }
    }
}
