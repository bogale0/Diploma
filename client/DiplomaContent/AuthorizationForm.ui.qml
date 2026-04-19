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
    id: item1
    readonly property int loginMode: 0
    readonly property int signupMode: 1
    property int authMode: loginMode
    property alias login: loginText.text
    property alias password: pswdText.text
    property alias authButton: authButton
    property alias errText: errText.text
    signal authSuccess()

    Rectangle {
        anchors.fill: parent
        color: "#06080f"
    }

    Rectangle {
        width: parent.width * 0.42
        height: parent.height * 0.62
        radius: 22
        color: "#10141f"
        border.color: "#2d3752"
        anchors.centerIn: parent

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 28
            spacing: 16

            Label {
                text: authMode === loginMode ? "Вход в аккаунт" : "Создание аккаунта"
                color: "#edf2ff"
                font.pixelSize: 28
                font.weight: Font.Bold
                Layout.fillWidth: true
            }

            Label {
                text: "Изучайте программирование на практике"
                color: "#99a8cf"
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                font.pixelSize: 14
            }

            Text {
                id: errText
                color: "#ef4444"
                font.pixelSize: 14
                Layout.fillWidth: true
                visible: text.length > 0
            }

            TextField {
                id: loginText
                Layout.fillWidth: true
                Layout.preferredHeight: 46
                placeholderText: "Логин"
            }

            TextField {
                id: pswdText
                Layout.fillWidth: true
                Layout.preferredHeight: 46
                echoMode: TextInput.Password
                placeholderText: "Пароль"
            }

            Button {
                id: authButton
                Layout.fillWidth: true
                Layout.preferredHeight: 48
                text: "Войти"

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

            Label {
                id: toggleLink
                color: "#a5b4fc"
                text: "Зарегистрироваться"
                font.pixelSize: 15
                font.underline: true
                Layout.alignment: Qt.AlignHCenter

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    Connections {
                        onClicked: {
                            let tmp = toggleLink.text;
                            toggleLink.text = authButton.text;
                            authButton.text = tmp;
                            if (authMode === loginMode) {
                                authMode = signupMode;
                            } else {
                                authMode = loginMode;
                            }
                        }
                    }
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }
}
