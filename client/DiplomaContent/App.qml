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
        initialItem: MainPage {} /*Authorization {
            onAuthSuccess: stack.replace("MainPage.qml");
        }*/
    }
}
