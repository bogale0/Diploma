import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 10

        Label { text: "Профиль пользователя" }

        TextField {
            placeholderText: "Имя"
        }

        TextField {
            placeholderText: "Email"
        }

        Button {
            text: "Сохранить"
        }
    }
}
