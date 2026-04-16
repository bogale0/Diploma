import QtQuick
import Backend 1.0

TaskPageForm {
    signal taskSolved()
    checkButton.onClicked: Api.checkSolution(task_id, codeText)
    Component.onCompleted: Api.getTask(task_id)

    Connections {
        target: Api

        function onTaskReceived(task) {
            taskContent = task
        }

        function onSolutionChecked(result) {
            resultText = result
        }
    }
}
