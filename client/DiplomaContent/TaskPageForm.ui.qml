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
    anchors.fill: parent
    spacing: 10
    padding: 15
    required property int theme_id
    property alias taskContent: contentLabel.text
    property alias codeText: codeEditor.text
    property alias checkButton: checkButton
    property alias resultText: resultLabel.text

    Label {
        id: contentLabel
        font.pixelSize: 22
    }

    TextArea {
        id: codeEditor
        placeholderText: "Введите код..."
    }

    Button {
        id: checkButton
        text: "Отправить на проверку"
    }

    Label {
        id: resultLabel
    }
}
