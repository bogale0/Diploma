/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/

import QtQuick
import QtQuick.Controls
import Diploma 1.0

Column {
    spacing: 10
    padding: 20
    property string theoryContent
    property alias taskButton: taskButton

    ScrollView {
        id: scrollView
        width: parent.width * 0.97
        height: parent.height * 0.8
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

        Text {
            width: scrollView.width
            wrapMode: Text.WordWrap
            padding: 10
            text: theoryContent
            font.pixelSize: 22
        }
    }

    Button {
        id: taskButton
        text: "Перейти к заданию"
    }
}
