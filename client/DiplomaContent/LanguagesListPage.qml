import QtQuick
import Backend 1.0

ListPageForm {
    detailedMode: true
    signal langChosen(int id)
    Component.onCompleted: Api.getLanguages()

    Connections {
        target: Api

        function onLanguagesReceived(langs) {
            items = langs
        }
    }

    Connections {
        function onItemChosen(id) {
            langChosen(id)
        }
    }
}
