import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Backend 1.0

Item {
    property int selectedLangId: -1
    property int selectedThemeId: -1
    property var languages: []
    property var themes: []

    Component.onCompleted: Api.getLanguages()

    Rectangle {
        anchors.fill: parent
        color: "#eaf2ff"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 12

        Label {
            text: "Панель учителя"
            font.pixelSize: 28
            font.weight: Font.Bold
            color: "#16345f"
        }

        TabBar {
            id: tabBar
            Layout.fillWidth: true
            TabButton { text: "Курсы" }
            TabButton { text: "Новая тема" }
            TabButton { text: "Новое задание" }
        }

        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: tabBar.currentIndex

            ScrollView {
                clip: true
                ColumnLayout {
                    width: parent.width
                    spacing: 8
                    Repeater {
                        model: languages
                        delegate: Rectangle {
                            width: parent.width
                            height: 70
                            radius: 12
                            color: "#d8e7ff"
                            border.color: "#9cb5db"
                            Text {
                                anchors.centerIn: parent
                                text: modelData.text + " (#" + modelData.id + ")"
                                color: "#16345f"
                                font.pixelSize: 20
                            }
                        }
                    }
                }
            }

            Flickable {
                contentWidth: width
                contentHeight: formTheme.implicitHeight
                clip: true

                ColumnLayout {
                    id: formTheme
                    width: parent.width
                    spacing: 10

                    ComboBox {
                        Layout.fillWidth: true
                        model: languages
                        textRole: "text"
                        onActivated: selectedLangId = model[currentIndex].id
                    }

                    TextField {
                        id: themeTopic
                        Layout.fillWidth: true
                        placeholderText: "Название темы"
                    }

                    TextArea {
                        id: themeTheory
                        Layout.fillWidth: true
                        Layout.preferredHeight: 220
                        placeholderText: "Теория (можно HTML)"
                        wrapMode: TextEdit.Wrap
                    }

                    Button {
                        text: "Добавить тему"
                        Layout.fillWidth: true
                        onClicked: {
                            if (selectedLangId > 0)
                                Api.createTheme(selectedLangId, themeTopic.text, themeTheory.text)
                        }
                    }
                }
            }

            Flickable {
                contentWidth: width
                contentHeight: formTask.implicitHeight
                clip: true

                ColumnLayout {
                    id: formTask
                    width: parent.width
                    spacing: 10

                    ComboBox {
                        id: langComboForTask
                        Layout.fillWidth: true
                        model: languages
                        textRole: "text"
                        onActivated: {
                            selectedLangId = model[currentIndex].id
                            Api.getThemes(selectedLangId)
                        }
                    }

                    ComboBox {
                        Layout.fillWidth: true
                        model: themes
                        textRole: "text"
                        onActivated: selectedThemeId = model[currentIndex].id
                    }

                    TextArea {
                        id: taskBody
                        Layout.fillWidth: true
                        Layout.preferredHeight: 170
                        placeholderText: "Текст задания"
                        wrapMode: TextEdit.Wrap
                    }

                    TextField {
                        id: publicIn
                        Layout.fillWidth: true
                        placeholderText: "Публичный входной пример"
                    }

                    TextField {
                        id: publicOut
                        Layout.fillWidth: true
                        placeholderText: "Публичный выходной пример"
                    }

                    Button {
                        text: "Добавить задание"
                        Layout.fillWidth: true
                        onClicked: {
                            if (selectedThemeId > 0)
                                Api.createTask(selectedThemeId, taskBody.text, publicIn.text, publicOut.text)
                        }
                    }
                }
            }
        }

        Label {
            id: statusLabel
            Layout.fillWidth: true
            color: "#234877"
            wrapMode: Text.Wrap
        }
    }

    Connections {
        target: Api

        function onLanguagesReceived(list) {
            languages = list
            if (list.length > 0 && selectedLangId <= 0) {
                selectedLangId = list[0].id
                Api.getThemes(selectedLangId)
            }
        }

        function onThemesReceived(list) {
            themes = list
            if (list.length > 0)
                selectedThemeId = list[0].id
        }

        function onThemeCreated(themeId) {
            statusLabel.text = "Тема добавлена: #" + themeId
            Api.getThemes(selectedLangId)
        }

        function onTaskCreated(taskId) {
            statusLabel.text = "Задание добавлено: #" + taskId
        }

        function onApiError(error) {
            statusLabel.text = error
        }
    }
}
