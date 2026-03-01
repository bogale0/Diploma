import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Diploma 1.0

ListView {
    signal themeChosen(int theme_id)

    model: [
        {id: 1, name: "Основы синтаксиса и переменные"},
        {id: 2, name: "Условия и циклы"},
        {id: 3, name: "Функции и массивы"}
    ]

    delegate: ItemDelegate {
        text: modelData.name
        width: parent.width
        onClicked: themeChosen(modelData.id);
    }
}
