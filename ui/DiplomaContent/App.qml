import QtQuick
import QtQuick.Controls
import Diploma 1.0

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
        initialItem: MainPage {user_id: 2}/*Authorization {
            onLoginSuccess: stack.replace("MainPage.qml", {"user_id": user_id})
        }*/
    }
}

