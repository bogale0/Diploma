import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 10

        Label { text: "Настройки" }

        ComboBox {
            model: ["Светлая тема", "Тёмная тема"]
        }

        CheckBox {
            text: "Кэшировать теорию"
        }
    }
}
