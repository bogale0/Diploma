import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Diploma 1.0

ColumnLayout {
    required property int user_id
    anchors.fill: parent

    Row {
        anchors.fill: parent
        spacing: 10

        Repeater {
            model: [
                {name: "Курсы", page: "CourseListPage.qml"},
                {name: "Прогресс", page: "ProgressPage.qml"},
                {name: "Профиль", page: "ProfilePage.qml"},
                {name: "Настройки", page: "SettingsPage.qml"}
            ]

            Button {
                text: modelData.name
                Layout.fillWidth: true
                onClicked: contentStack.replace(modelData.page)
            }
        }
    }

    StackView {
        id: contentStack
        Layout.fillWidth: true
        Layout.fillHeight: true
        initialItem: "CourseListPage.qml"

        onCurrentItemChanged: {
            if (!currentItem)
                return;

            if (currentItem.themeChosen) {
                currentItem.themeChosen.connect(function(a) {
                    contentStack.push("TheoryPage.qml", {titleText: currentItem.titleText});
                })
            }
        }
    }
}
