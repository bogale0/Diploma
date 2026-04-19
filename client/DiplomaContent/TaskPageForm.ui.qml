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

Item {
    anchors.fill: parent
    required property int task_id
    property alias taskContent: contentLabel.text
    property alias codeText: codeEditor.text
    property alias checkButton: checkButton
    property alias resultText: resultLabel.text

    function escapeHtml(text) {
        return text
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;");
    }

    function highlightedText(sourceText, lang) {
        let safe = escapeHtml(sourceText);
        let keywords;
        if (lang === "Python") {
            keywords = ["def", "class", "import", "from", "return", "if", "elif", "else", "for", "while", "in", "try", "except", "with", "as", "lambda", "None", "True", "False", "and", "or", "not"];
        } else {
            keywords = ["int", "double", "float", "bool", "char", "void", "auto", "const", "return", "if", "else", "for", "while", "switch", "case", "class", "struct", "namespace", "std", "include", "using", "public", "private", "protected", "template"];
        }

        for (let i = 0; i < keywords.length; i++) {
            let expr = new RegExp("\\\\b" + keywords[i] + "\\\\b", "g");
            safe = safe.replace(expr, "<font color='#c084fc'><b>" + keywords[i] + "</b></font>");
        }

        safe = safe.replace(/("[^"]*"|'[^']*')/g, "<font color='#7dd3fc'>$1</font>");
        safe = safe.replace(/(\/\/.*$)/gm, "<font color='#86efac'>$1</font>");
        safe = safe.replace(/(#.*$)/gm, "<font color='#86efac'>$1</font>");
        safe = safe.replace(/\n/g, "<br>");
        return safe;
    }

    Rectangle {
        anchors.fill: parent
        color: "#0d111b"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 10

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            radius: 14
            color: "#121826"
            border.color: "#2d3752"

            ScrollView {
                anchors.fill: parent
                anchors.margins: 12
                clip: true
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                Label {
                    id: contentLabel
                    width: parent.width
                    wrapMode: Text.Wrap
                    color: "#edf2ff"
                    font.pixelSize: 18
                    lineHeight: 1.25
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 46
            radius: 10
            color: "#121826"
            border.color: "#2d3752"

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12

                Label {
                    text: "Язык подсветки:"
                    color: "#c8d3f5"
                    font.pixelSize: 14
                }

                ComboBox {
                    id: languageBox
                    model: ["C++", "Python"]
                    Layout.preferredWidth: 140
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 14
            color: "#0a0f1d"
            border.color: "#2d3752"

            TextArea {
                id: codeEditor
                anchors.fill: parent
                anchors.margins: 10
                color: "#d8e5ff"
                font.family: "Fira Code"
                font.pixelSize: 16
                wrapMode: TextEdit.NoWrap
                selectByMouse: true
                background: Rectangle {
                    color: "transparent"
                }
            }

            Text {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 16
                anchors.topMargin: 16
                text: "Введите код..."
                color: "#6f7ea6"
                font.pixelSize: 16
                visible: codeEditor.length === 0
                font.family: "Fira Code"
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 160
            radius: 14
            color: "#0f1526"
            border.color: "#2d3752"

            ScrollView {
                anchors.fill: parent
                anchors.margins: 10
                clip: true

                Text {
                    width: parent.width
                    textFormat: Text.RichText
                    text: highlightedText(codeEditor.text, languageBox.currentText)
                    color: "#d8e5ff"
                    font.family: "Fira Code"
                    font.pixelSize: 15
                }
            }
        }

        Button {
            id: checkButton
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            text: "Отправить на проверку"

            background: Rectangle {
                radius: 12
                color: parent.down ? "#6d28d9" : parent.hovered ? "#5b34b8" : "#4c1d95"
            }

            contentItem: Text {
                text: parent.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "#ffffff"
                font.pixelSize: 16
                font.weight: Font.DemiBold
            }
        }

        Label {
            id: resultLabel
            Layout.fillWidth: true
            color: "#d9e2ff"
            wrapMode: Text.Wrap
            font.pixelSize: 15
        }
    }
}
