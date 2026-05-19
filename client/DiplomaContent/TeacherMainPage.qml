import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Backend 1.0

Item {
    signal loggedOut()
    property int selectedLangId: -1
    property int selectedThemeId: -1
    property int selectedTaskId: -1
    property var languages: []
    property var themes: []
    property var tasks: []

    Component.onCompleted: Api.getLanguages()

    Rectangle {
        anchors.fill: parent
        color: "#eaf2ff"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 14

        Label {
            text: "Панель учителя"
            font.pixelSize: 36
            font.weight: Font.Bold
            color: "#16345f"
        }

        TabBar {
            id: tabBar
            Layout.fillWidth: true
            TabButton { text: "Новый курс" }
            TabButton { text: "Новая тема" }
            TabButton { text: "Новое задание" }
            TabButton { text: "Новый тест" }
            TabButton {
                text: "Выйти"
                onClicked: {
                    Api.logout()
                    loggedOut()
                }
            }
        }

        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: tabBar.currentIndex

            Flickable {
                contentWidth: width
                contentHeight: formLanguage.implicitHeight
                clip: true

                ColumnLayout {
                    id: formLanguage
                    width: parent.width
                    spacing: 10

                    TextField {
                        id: languageName
                        Layout.fillWidth: true
                        placeholderText: "Название курса (языка)"
                    }

                    TextField {
                        id: languageShort
                        Layout.fillWidth: true
                        placeholderText: "Краткое описание (необязательно)"
                    }

                    TextField {
                        id: languagePhoto
                        Layout.fillWidth: true
                        placeholderText: "URL картинки (необязательно)"
                    }

                    Button {
                        text: "Добавить курс"
                        Layout.fillWidth: true
                        onClicked: {
                            if (languageName.text.trim() !== "")
                                Api.createLanguage(languageName.text, languageShort.text, languagePhoto.text)
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
                            if (selectedLangId > 0 && themeTopic.text.trim() !== "" && themeTheory.text.trim() !== "")
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
                            selectedThemeId = -1
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
                            if (selectedThemeId > 0 && taskBody.text.trim() !== "")
                                Api.createTask(selectedThemeId, taskBody.text, publicIn.text, publicOut.text)
                        }
                    }
                }
            }

            Flickable {
                contentWidth: width
                contentHeight: formTest.implicitHeight
                clip: true

                ColumnLayout {
                    id: formTest
                    width: parent.width
                    spacing: 10

                    ComboBox {
                        id: langComboForTest
                        Layout.fillWidth: true
                        model: languages
                        textRole: "text"
                        onActivated: {
                            selectedLangId = model[currentIndex].id
                            selectedThemeId = -1
                            selectedTaskId = -1
                            themes = []
                            tasks = []
                            Api.getThemes(selectedLangId)
                        }
                    }

                    ComboBox {
                        id: themeComboForTest
                        Layout.fillWidth: true
                        model: themes
                        textRole: "text"
                        onActivated: {
                            selectedThemeId = model[currentIndex].id
                            selectedTaskId = -1
                            tasks = []
                            Api.getTasks(selectedThemeId)
                        }
                    }

                    ComboBox {
                        id: taskComboForTest
                        Layout.fillWidth: true
                        model: tasks
                        textRole: "text"
                        onActivated: selectedTaskId = model[currentIndex].id
                    }

                    TextArea {
                        id: testInput
                        Layout.fillWidth: true
                        Layout.preferredHeight: 120
                        placeholderText: "Входные данные теста"
                        wrapMode: TextEdit.Wrap
                    }

                    TextArea {
                        id: testOutput
                        Layout.fillWidth: true
                        Layout.preferredHeight: 120
                        placeholderText: "Ожидаемый вывод теста"
                        wrapMode: TextEdit.Wrap
                    }

                    Button {
                        text: "Добавить тест"
                        Layout.fillWidth: true
                        onClicked: {
                            if (selectedTaskId > 0 && testInput.text.trim() !== "" && testOutput.text.trim() !== "")
                                Api.createTest(selectedTaskId, testInput.text, testOutput.text)
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
            if (list.length > 0) {
                selectedThemeId = list[0].id
                Api.getTasks(selectedThemeId)
            }
        }

        function onTasksReceived(list) {
            tasks = list
            if (list.length > 0)
                selectedTaskId = list[0].id
        }

        function onLanguageCreated(languageId) {
            statusLabel.text = "Курс добавлен: #" + languageId
            Api.getLanguages()
        }

        function onThemeCreated(themeId) {
            statusLabel.text = "Тема добавлена: #" + themeId
            Api.getThemes(selectedLangId)
        }

        function onTaskCreated(taskId) {
            statusLabel.text = "Задание добавлено: #" + taskId
        }

        function onTestCreated(testId) {
            statusLabel.text = "Тест добавлен: #" + testId
        }

        function onApiError(error) {
            statusLabel.text = error
        }
    }
}
