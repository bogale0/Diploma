import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Diploma 1.0

Column {
    anchors.fill: parent
    spacing: 10
    padding: 15
    required property int theme_id
    required property int user_id
    property var tasksContent: ['<b>Задание</b><br>Напиши простую программу, которая:<ol><li>Запрашивает у пользователя два числа.</li><li>Выводит их сумму.</li><li>Выводит приветствие с именем пользователя.</li><li>Цель: научиться создавать переменные, использовать типы данных и базовый ввод/вывод.</li><blockquote><p>Цель: научиться создавать переменные, использовать типы данных и базовый ввод/вывод.</p></blockquote>']
    //signal taskDemanded(int theme_id)

    Label {
        text: tasksContent[theme_id - 1]
        font.pixelSize: 22
    }

    TextArea {
        id: codeEditor
        placeholderText: "Введите код..."
    }

    RowLayout {

        Button {
            text: "Отправить на проверку"

            onClicked: {
                let xhr = new XMLHttpRequest();
                xhr.open("POST", Constants.endpoint + "/check_task.php");
                xhr.setRequestHeader("Content-Type", "application/json");
                xhr.onload = function() {
                    if (xhr.status >= 200 && xhr.status < 300) {
                        let response = JSON.parse(xhr.responseText);
                        if (response.status === "ok") {
                            resultLabel.text = "Успех";
                        } else if (response.status === "wrong_answer") {
                            resultLabel.text = "Неверно";
                        } else if (response.status === "compile_error") {
                            resultLabel.text = "Ошибка компиляции: " + response.error;
                        } else {
                            resultLabel.text = "Ошибка: " + xhr.responseText;
                        }
                    } else {
                        resultLabel.text = "Ошибка: " + xhr.responseText;
                    }
                }
                xhr.send(JSON.stringify({
                    code: codeEditor.text,
                    user_id: user_id,
                    theme_id: theme_id
                }));
            }
        }

        Button {
            text: "Очистить"

            onClicked: {
                codeEditor.text = ""
            }
        }
    }

    Label {
        id: resultLabel
        text: ""
    }
}
