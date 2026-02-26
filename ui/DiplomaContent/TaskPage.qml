import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Diploma 1.0

Column {
    anchors.fill: parent
    spacing: 10
    padding: 15
    required property int theme_id
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
                resultLabel.text = "Код отправлен (заглушка)"
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
