import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Diploma 1.0

Column {
    property string titleText: ""
    anchors.fill: parent
    spacing: 10
    padding: 20

    Label {
        text: titleText
        font.pixelSize: 24
    }

    ScrollView {
        Layout.fillWidth: true
        Layout.fillHeight: true

        Text {
            width: parent.width
            wrapMode: Text.Wrap
            text: "Здесь будет теоретический материал..."
        }
    }

    Button {
        text: "Перейти к заданию"

        Connections {
            target: parent
            onClicked: StackView.view.push("TaskPage.qml")
        }
    }
}
