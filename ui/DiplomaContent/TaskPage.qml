import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Diploma 1.0

Page {
    Column {
        anchors.fill: parent
        spacing: 10
        padding: 15

        Label {
            text: "Практическое задание"
            font.pixelSize: 22
        }

        TextArea {
            id: codeEditor
            Layout.fillWidth: true
            Layout.fillHeight: true
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
}
