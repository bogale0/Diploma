import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Diploma 1.0

Flickable {
    anchors.fill: parent
    contentWidth: width
    contentHeight: container.implicitHeight + 30
    clip: true
    required property bool isTaskSolved
    property var completedThemes: []
    property var pendingThemes: []

    Component.onCompleted: {
        completedThemes = isTaskSolved ? ["Основы синтаксиса и переменные"] : [];
        pendingThemes = isTaskSolved ? ["Условия и циклы", "Функции и массивы"] : ["Основы синтаксиса и переменные", "Условия и циклы", "Функции и массивы"];
    }


    ColumnLayout {
        id: container
        width: parent.width
        spacing: 14
        anchors.margins: 20
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top

        Rectangle {
            Layout.fillWidth: true
            radius: 14
            color: "#eef6fb"
            border.color: "#bfd7ea"
            border.width: 1
            implicitHeight: cardColumn.implicitHeight + 20

            ColumnLayout {
                id: cardColumn
                anchors.fill: parent
                anchors.margins: 16
                spacing: 8

                Label {
                    text: "Прогресс обучения"
                    font.pixelSize: 24
                    font.bold: true
                }

                ProgressBar {
                    Layout.fillWidth: true
                    value: isTaskSolved * 33 / 100
                }

                Label {
                    text: "Выполнено " + (isTaskSolved * 33) + "%"
                    font.pixelSize: 16
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            radius: 14
            color: "#f2fff4"
            border.color: "#a8ddb5"
            border.width: 1
            implicitHeight: doneColumn.implicitHeight + 20

            ColumnLayout {
                id: doneColumn
                anchors.fill: parent
                anchors.margins: 16
                spacing: 8

                Label {
                    text: "✅ Пройденные темы"
                    font.pixelSize: 20
                    font.bold: true
                }

                Repeater {
                    model: completedThemes
                    delegate: Label {
                        text: "• " + modelData
                        font.pixelSize: 16
                    }
                }

                Label {
                    visible: completedThemes.length === 0
                    text: "Пока нет пройденных тем"
                    color: "#5d6d7e"
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            radius: 14
            color: "#fff5f5"
            border.color: "#f1b0b7"
            border.width: 1
            implicitHeight: todoColumn.implicitHeight + 20

            ColumnLayout {
                id: todoColumn
                anchors.fill: parent
                anchors.margins: 16
                spacing: 8

                Label {
                    text: "📚 Непройденные темы"
                    font.pixelSize: 20
                    font.bold: true
                }

                Repeater {
                    model: pendingThemes
                    delegate: Label {
                        text: "• " + modelData
                        font.pixelSize: 16
                    }
                }

                Label {
                    visible: pendingThemes.length === 0
                    text: "Все темы пройдены. Отличная работа!"
                    color: "#2e7d32"
                }
            }
        }
    }
}
