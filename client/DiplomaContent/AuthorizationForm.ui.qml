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
        width: parent.width
        height: parent.height * 0.6
        color: Constants.blueBgColor
    }

    Rectangle {
        width: parent.width * 0.5
        height: parent.height * 0.6
        color: "#d7e2e7"
        radius: 15
        border.color: "#dbbcbc"
        border.width: 1
        anchors.centerIn: parent

        Text {
            id: errText
            anchors.horizontalCenter: parent.horizontalCenter
            y: parent.height * 0.05
            color: "#ff0000"
            font.pixelSize: 20
        }

        ColumnLayout {
            anchors.centerIn: parent
            width: parent.width * 0.4
            spacing: 15

            TextField {
                id: loginText
                Layout.fillWidth: true
                placeholderText: "Логин"
            }

            TextField {
                id: pswdText
                Layout.fillWidth: true
                echoMode: TextInput.Password
                placeholderText: "Пароль"
            }

            Button {
                id: authButton
                Layout.fillWidth: true
                text: "Войти"
            }

            Label {
                id: toggleLink
                color: "#0000ff"
                text: "Зарегистрироваться"
                font.pixelSize: 16
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
        }
    }
}
