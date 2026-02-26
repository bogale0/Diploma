import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Diploma 1.0

ColumnLayout {
    property alias errText: errText.text
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
            width: parent.width
            onClicked: {
                langChosen(modelData.id);
            }
        }
    }

    Text {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.bottomMargin: -10
        Layout.leftMargin: 15

        id: errText
        color: "red"
        font.pixelSize: 16
    }
}
