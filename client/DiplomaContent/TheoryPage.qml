import QtQuick
import Backend 1.0

TheoryPageForm {
    required property int theme_id
    signal taskDemanded(int id)
    Component.onCompleted: Api.getTheory(theme_id)
    taskButton.onClicked: taskDemanded(theme_id)

    Connections {
        target: Api

        function onTheoryReceived(text) {
            theoryContent = text
        }
    }
}
