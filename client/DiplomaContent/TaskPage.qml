import QtQuick
import Backend 1.0

TaskPageForm {
    signal taskSolved(int id)
    runButton.onClicked: Api.runSolution(codeText, runInputText)
    submitButton.onClicked: Api.checkSolution(task_id, codeText)
    Component.onCompleted: Api.getTask(task_id)

    Connections {
        target: Api

        function onApiError(err) {
            // Make sure errors from check_task (e.g. 401) are visible to user
            resultText = err
        }

        function onTaskReceived(task, publicInput, publicOutput) {
            taskContent = task
            publicInputText = publicInput
            publicOutputText = publicOutput
        }

        function onSolutionRan(result, output) {
            runOutputText = output
            resultText = result
        }

        function onSolutionChecked(result) {
            resultText = result
        }
    }
}
