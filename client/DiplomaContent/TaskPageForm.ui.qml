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
        color: "#f3f8ff"
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
                color: "#e8f1ff"
                border.color: "#9cb5db"

                ScrollView {
                    anchors.fill: parent
                    anchors.margins: 10
                    clip: true

                    TextArea {
                        id: codeEditor
                        width: parent.width
                        height: Math.max(parent.height, contentHeight)
                        color: "#1d3d6b"
                        font.family: "Fira Code"
                        font.pixelSize: 16
                        leftPadding: 8
                        topPadding: 8
                        wrapMode: TextEdit.NoWrap
                        selectByMouse: true
                        background: Rectangle {
                            color: "transparent"
                        }
                    }

                    Text {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.margins: 18
                        text: "Введите код..."
                        color: "#7a9bc8"
                        font.family: "Fira Code"
                        font.pixelSize: 16
                        visible: codeEditor.text.length === 0
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 14
                color: "#e1edff"
                border.color: "#9cb5db"

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
                            color: "#16345f"
                            font.pixelSize: 18
                            lineHeight: 1.25
                        }
                    }

                    Label {
                        text: "Пример"
                        color: "#16345f"
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
                            color: "#1d3d6b"
                            placeholderTextColor: "#6b89b8"
                            font.pixelSize: 14
                            placeholderText: "Вход"
                            background: Rectangle {
                                radius: 8
                                color: "#f6f9ff"
                                border.color: "#9cb5db"
                            }
                        }

                        TextField {
                            id: publicOutput
                            Layout.fillWidth: true
                            Layout.preferredHeight: 30
                            readOnly: true
                            color: "#1d3d6b"
                            placeholderTextColor: "#6b89b8"
                            font.pixelSize: 14
                            placeholderText: "Выход"
                            background: Rectangle {
                                radius: 8
                                color: "#f6f9ff"
                                border.color: "#9cb5db"
                            }
                        }
                    }

                    Label {
                        text: "Свой тест"
                        color: "#16345f"
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
                            color: "#1d3d6b"
                            placeholderTextColor: "#6b89b8"
                            font.pixelSize: 14
                            placeholderText: "Вход"
                            background: Rectangle {
                                radius: 8
                                color: "#f6f9ff"
                                border.color: "#9cb5db"
                            }
                        }

                        TextField {
                            id: runOutput
                            Layout.fillWidth: true
                            Layout.preferredHeight: 30
                            readOnly: true
                            color: "#1d3d6b"
                            placeholderTextColor: "#6b89b8"
                            font.pixelSize: 14
                            placeholderText: "Выход"
                            background: Rectangle {
                                radius: 8
                                color: "#f6f9ff"
                                border.color: "#9cb5db"
                            }
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Button {
                id: submitButton
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                text: "Отправить"

                background: Rectangle {
                    radius: 12
                    color: parent.down ? "#4f8ef7" : parent.hovered ? "#3f7ee8" : "#316ad1"
                }

                contentItem: Text {
                    text: parent.text
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "#f8fbff"
                    font.pixelSize: 16
                    font.weight: Font.DemiBold
                }
            }

            Button {
                id: runButton
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                text: "Запустить"

                background: Rectangle {
                    radius: 12
                    color: parent.down ? "#4a8eff" : parent.hovered ? "#3e80f1" : "#2f6cd4"
                }

                contentItem: Text {
                    text: parent.text
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "#f8fbff"
                    font.pixelSize: 16
                    font.weight: Font.DemiBold
                }
            }
        }

        Label {
            id: resultLabel
            Layout.fillWidth: true
            color: "#234877"
            wrapMode: Text.Wrap
            font.pixelSize: 15
        }
    }
}
