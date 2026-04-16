import QtQuick
import Backend 1.0

TaskPageForm {
    signal taskSolved()
    checkButton.onClicked: Api.checkSolution(theme_id, codeText)
    Component.onCompleted: Api.getTask(theme_id)

    Connections {
        target: Api

        function onTaskReceived(task) {
            taskContent = task
        }

        function onSolutionChecked(text) {
            resultText = text
        }
    }
}
