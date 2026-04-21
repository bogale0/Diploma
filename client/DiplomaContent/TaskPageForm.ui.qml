/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Diploma 1.0

Item {
    anchors.fill: parent
    required property int task_id
    property alias taskContent: contentLabel.text
    property alias codeText: codeEditor.text
    property alias runInputText: runInput.text
    property alias runOutputText: runOutput.text
    property alias publicInputText: publicInput.text
    property alias publicOutputText: publicOutput.text
    property alias runButton: runButton
    property alias submitButton: submitButton
    property alias resultText: resultLabel.text

    Rectangle {
        anchors.fill: parent
        color: "#0d111b"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 14
                color: "#0a0f1d"
                border.color: "#2d3752"

                ScrollView {
                    anchors.fill: parent
                    anchors.margins: 10
                    clip: true

                    TextArea {
                        id: codeEditor
                        width: parent.width
                        height: Math.max(parent.height, contentHeight)
                        color: "#d8e5ff"
                        font.family: "Fira Code"
                        font.pixelSize: 16
                        wrapMode: TextEdit.NoWrap
                        placeholderTextColor: "#60ffffff"
                        placeholderText: "Введите код..."
                        selectByMouse: true
                        background: Rectangle {
                            color: "transparent"
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 14
                color: "#121826"
                border.color: "#2d3752"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 8

                    ScrollView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                        Label {
                            id: contentLabel
                            width: parent.width
                            wrapMode: Text.Wrap
                            color: "#edf2ff"
                            font.pixelSize: 18
                            lineHeight: 1.25
                        }
                    }

                    Label {
                        text: "Пример"
                        color: "#edf2ff"
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                    }


                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        TextField {
                            id: publicInput
                            Layout.fillWidth: true
                            Layout.preferredHeight: 30
                            readOnly: true
                            color: "#d8e5ff"
                            font.pixelSize: 14
                            placeholderText: "Вход"
                        }

                        TextField {
                            id: publicOutput
                            Layout.fillWidth: true
                            Layout.preferredHeight: 30
                            readOnly: true
                            color: "#d8e5ff"
                            font.pixelSize: 14
                            placeholderText: "Выход"
                        }
                    }

                    Label {
                        text: "Свой тест"
                        color: "#edf2ff"
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        TextField {
                            id: runInput
                            Layout.fillWidth: true
                            Layout.preferredHeight: 30
                            color: "#d8e5ff"
                            font.pixelSize: 14
                            placeholderText: "Вход"
                        }

                        TextField {
                            id: runOutput
                            Layout.fillWidth: true
                            Layout.preferredHeight: 30
                            readOnly: true
                            color: "#d8e5ff"
                            font.pixelSize: 14
                            placeholderText: "Выход"
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Button {
                id: runButton
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                text: "Запустить"

                background: Rectangle {
                    radius: 12
                    color: parent.down ? "#2563eb" : parent.hovered ? "#1d4ed8" : "#1e40af"
                }

                contentItem: Text {
                    text: parent.text
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "#ffffff"
                    font.pixelSize: 16
                    font.weight: Font.DemiBold
                }
            }

            Button {
                id: submitButton
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                text: "Отправить"

                background: Rectangle {
                    radius: 12
                    color: parent.down ? "#6d28d9" : parent.hovered ? "#5b34b8" : "#4c1d95"
                }

                contentItem: Text {
                    text: parent.text
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "#ffffff"
                    font.pixelSize: 16
                    font.weight: Font.DemiBold
                }
            }
        }

        Label {
            id: resultLabel
            Layout.fillWidth: true
            color: "#d9e2ff"
            wrapMode: Text.Wrap
            font.pixelSize: 15
        }
    }
}
