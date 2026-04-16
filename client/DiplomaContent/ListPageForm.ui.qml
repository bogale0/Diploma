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

Column {
    property var items
    signal itemChosen(int id)

    ListView {
        anchors.fill: parent
        model: items

        delegate: ItemDelegate {
            text: modelData.text

            anchors {
                left: parent.left
                right: parent.right
                leftMargin: 10
            }

            Connections {
                onClicked: itemChosen(modelData.id)
            }
        }
    }
}
