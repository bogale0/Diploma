import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Diploma 1.0

ListView {
    anchors.fill: parent
    property string titleText
    signal themeChosen()

    model: [
        "Основы C++",
        "Алгоритмы",
        "Структуры данных"
    ]

    delegate: ItemDelegate {
        text: modelData
        width: parent.width

        onClicked: {
            titleText = modelData;
            themeChosen();
        }
    }
}
