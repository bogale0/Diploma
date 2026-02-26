import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Diploma 1.0

Page {

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 10

        Label {
            text: "Прогресс обучения"
            font.pixelSize: 22
        }

        ProgressBar {
            value: 0.45
            width: 300
        }

        Label {
            text: "Выполнено 45%"
        }
    }
}
