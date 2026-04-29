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
    property alias selectedRole: roleCombo.currentValue
    signal authSuccess()

    Rectangle {
        anchors.fill: parent
        color: "#eaf2ff"
    }

    Image {
        source: "qrc:/qt/qml/DiplomaContent/images/icon.png"
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        anchors.top: parent.top
        anchors.bottom: contentRect.top
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Rectangle {
        id: contentRect
        width: parent.width * 0.5
        height: column.height + 20
        anchors.centerIn: parent
        radius: 22
        color: "#dce9ff"
        border.color: "#9cb5db"

        ColumnLayout {
            id: column
            width: parent.width - 40
            anchors.centerIn: parent
            anchors.margins: 28
            spacing: 16

            Label {
                text: authMode === loginMode ? "Вход в аккаунт" : "Создание аккаунта"
                color: "#16345f"
                font.pixelSize: 28
                font.weight: Font.Bold
                Layout.fillWidth: true
            }

            Label {
                text: "Изучайте программирование на практике"
                color: "#4e6f9f"
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                font.pixelSize: 14
            }

            Text {
                id: errText
                color: "#cc3b3b"
                font.pixelSize: 14
                Layout.fillWidth: true
                visible: text.length > 0
            }

            TextField {
                id: loginText
                Layout.fillWidth: true
                Layout.preferredHeight: 46
                color: "#16345f"
                placeholderTextColor: "#6b89b8"
                placeholderText: "Логин"
                background: Rectangle {
                    radius: 10
                    color: "#f6f9ff"
                    border.color: "#9cb5db"
                }
            }

            ComboBox {
                id: roleCombo
                Layout.fillWidth: true
                Layout.preferredHeight: 46
                visible: authMode === signupMode
                model: [
                    { text: "Ученик", value: "student" },
                    { text: "Учитель", value: "teacher" }
                ]
                textRole: "text"
                valueRole: "value"

                background: Rectangle {
                    radius: 10
                    color: "#f6f9ff"
                    border.color: "#9cb5db"
                }
            }

            TextField {
                id: pswdText
                Layout.fillWidth: true
                Layout.preferredHeight: 46
                echoMode: TextInput.Password
                color: "#16345f"
                placeholderTextColor: "#6b89b8"
                placeholderText: "Пароль"
                background: Rectangle {
                    radius: 10
                    color: "#f6f9ff"
                    border.color: "#9cb5db"
                }
            }

            Button {
                id: authButton
                Layout.fillWidth: true
                Layout.preferredHeight: 48
                text: "Войти"

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

            Label {
                id: toggleLink
                color: "#2f63b2"
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
