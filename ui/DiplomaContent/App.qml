import QtQuick
import QtQuick.Controls
import Diploma

Window {
    width: maximumWidth
    height: maximumHeight
    minimumWidth: 1024
    minimumHeight: 576
    visible: true
    color: Constants.backgroundColor
    title: "Школа программирования"

    StackView {
        id: stack
        anchors.fill: parent
        initialItem: Authorization {
            onLoginSuccess: {
                stack.push("MainPage.qml", {"user_id": user_id});
            }
        }
    }
}

