import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Diploma 1.0

Item {
    property int authMode: Constants.loginMode
    signal loginSuccess(int user_id)

    Rectangle {
        width: parent.width
        height: parent.height * 0.6
        color: "#83abbd"
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
                id: actionBtn
                Layout.fillWidth: true
                text: "Войти"

                onClicked: {
                    let method;
                    switch (authMode) {
                    case Constants.loginMode:
                        method = "/login.php";
                        break;
                    case Constants.signupMode:
                        method = "/signup.php";
                        break;
                    }
                    let xhr = new XMLHttpRequest();
                    xhr.open("POST", Constants.endpoint + method);
                    xhr.setRequestHeader("Content-Type", "application/json");
                    xhr.onload = function() {
                        if (xhr.status >= 200 && xhr.status < 300) {
                            let response = JSON.parse(xhr.responseText);
                            loginSuccess(response["user_id"]);
                        } else {
                            errText.text = xhr.responseText;
                        }
                    }
                    xhr.send(JSON.stringify({
                        name: loginText.text,
                        password: pswdText.text
                    }));
                }
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

                    onClicked: {
                        let tmp = toggleLink.text;
                        toggleLink.text = actionBtn.text;
                        actionBtn.text = tmp;
                        if (authMode === Constants.loginMode) {
                            authMode = Constants.signupMode;
                        } else {
                            authMode = Constants.loginMode;
                        }
                    }
                }
            }
        }
    }
}
