import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Diploma 1.0

ColumnLayout {
    signal langChosen(int lang_id)

    ListView {
        Layout.fillWidth: true
        Layout.fillHeight: true

        model: [
            {id: 1, name: "C++"},
            {id: 2, name: "Python"}
        ]

        delegate: ItemDelegate {
            text: modelData.name
            anchors {
                left: parent.left
                right: parent.right
                leftMargin: 10
            }
            onClicked: langChosen(modelData.id)
        }
    }
}
