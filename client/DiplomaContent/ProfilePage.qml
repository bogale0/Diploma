import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Backend 1.0

Item {
    signal loggedOut()
    property var completedThemes: []
    property var pendingThemes: []
    property int overallProgress: 0

    Component.onCompleted: Api.getProgress()

    Rectangle { anchors.fill: parent; color: "#f3f8ff" }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 12

        Label { text: "Личный кабинет"; font.pixelSize: 28; font.weight: Font.Bold; color: "#16345f" }
        Label { text: "Общий прогресс: " + overallProgress + "%"; color: "#234877"; font.pixelSize: 18 }

        Label { text: "Завершённые темы"; font.pixelSize: 18; color: "#16345f" }
        Repeater {
            model: completedThemes
            delegate: Label { text: "• " + modelData.topic; color: "#2a5f2a" }
        }

        Label { text: "Темы в процессе"; font.pixelSize: 18; color: "#16345f" }
        Repeater {
            model: pendingThemes
            delegate: Label { text: "• " + modelData.topic; color: "#7a5a21" }
        }

        Item { Layout.fillHeight: true }

        Button {
            text: "Выйти из аккаунта"
            Layout.fillWidth: true
            onClicked: {
                Api.logout()
                loggedOut()
            }
        }
    }

    Connections {
        target: Api
        function onProgressReceived(data) {
            overallProgress = data.overall_progress
            completedThemes = data.completed_themes
            pendingThemes = data.pending_themes
        }
    }
}
