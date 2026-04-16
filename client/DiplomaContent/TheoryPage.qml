import QtQuick
import Backend 1.0

TheoryPageForm {
    required property int theme_id
    signal taskDemanded(int id)
    Component.onCompleted: Api.getTheory(theme_id)

    Connections {
        target: Api

        function onTheoryReceived(obj) {
            taskList = obj["tasks"]
            theoryContent = obj["theory"]
        }
    }

    Connections {
        function onTaskChosen(task_id) {
            taskDemanded(task_id)
        }
    }
}
