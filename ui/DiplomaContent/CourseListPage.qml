import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Diploma 1.0

ListView {
    anchors.fill: parent

    model: [
        "Основы C++",
        "Алгоритмы",
        "Структуры данных"
    ]

    delegate: ItemDelegate {
        text: modelData
        width: parent.width

        onClicked: {
            console.log("TheoryPage.qml " + modelData)
        }
    }
}
