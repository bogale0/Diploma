import QtQuick
import Backend 1.0

TaskPageForm {
    signal taskSolved(int id)
    runButton.onClicked: Api.runSolution(task_id, codeText, runInputText)
    submitButton.onClicked: Api.checkSolution(task_id, codeText)
    Component.onCompleted: Api.getTask(task_id)

    function resetResultBanner() {
        resultBadgeText = ""
        resultPrimaryText = ""
        resultSubtitleText = ""
        resultAccentColor = "#316ad1"
    }

    function presentRunBanner(status, stdoutText) {
        resultBadgeText = "Запуск кода"
        if (status === "Успешно") {
            resultPrimaryText = "Программа выполнилась без ошибки"
            resultAccentColor = "#2fa34d"
            const tail = stdoutText.trim()
            resultSubtitleText = tail.length ? tail : "Вывод пуст: вы можете вывести отладочную информацию (C++: cout, Python: print, C#: Console.WriteLine, Go: fmt.Println)."
            return
        }
        resultPrimaryText = status
        resultAccentColor = status.indexOf("компиляц") !== -1 ? "#c73d3d" : "#cf6a35"
        resultSubtitleText = "Проверьте синтаксис вывода или попробуйте другой вход — подсказку смотрите в разделе «Пример»."
    }

    function presentCheckBanner(line) {
        const m = /^Тестов пройдено:\s*(\d+)\s*\/\s*(\d+)$/.exec(line.trim())
        resultBadgeText = "Проверка по тестам"
        if (m) {
            const passed = Number(m[1])
            const total = Number(m[2])
            if (total <= 0) {
                resultPrimaryText = "Проверка не удалась или тестов нет"
                resultAccentColor = "#c73d3d"
                resultSubtitleText = "Частый случай при 0 из 0 — ошибка компиляции решения перед тестами. Убедитесь, что программа успешно проходит шаг «Запустить»."
                return
            }
            if (passed >= total) {
                resultPrimaryText = "Отлично: решение принято"
                resultAccentColor = "#2fa34d"
                resultSubtitleText = "Пройдены все автоматические тесты («Отправить»)."
            } else {
                resultPrimaryText = "Нужно доработать решение"
                resultAccentColor = "#d9862a"
                resultSubtitleText = "Сейчас " + passed + " из " + total + ". Сформированный вывод и перевод строки должны точно совпадать с ожиданием."
            }
            return
        }
        resultPrimaryText = line.length ? line : "Ответ без текста"
        resultAccentColor = "#316ad1"
    }

    function presentApiErrorBanner(message) {
        resultBadgeText = "Запрос"
        resultPrimaryText = message.length ? message : "Произошла ошибка"
        resultAccentColor = "#c73d3d"
        resultSubtitleText = "Проверьте авторизацию и соединение с сервером, затем повторите отправку."
    }

    Connections {
        target: Api

        function onApiError(err) {
            presentApiErrorBanner(err)
        }

        function onTaskReceived(task, publicInput, publicOutput) {
            resetResultBanner()
            taskContent = task
            publicInputText = publicInput
            publicOutputText = publicOutput
        }

        function onSolutionRan(result, output) {
            runOutputText = output
            presentRunBanner(result, output)
        }

        function onSolutionChecked(result) {
            presentCheckBanner(result)
        }
    }
}
