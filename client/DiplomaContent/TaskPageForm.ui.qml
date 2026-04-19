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

    Rectangle {
        anchors.fill: parent
        color: "#f5f8ff"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            radius: 14
            color: "#ffffff"
            border.color: "#d7e3ff"

            Label {
                id: contentLabel
                anchors.fill: parent
                anchors.margins: 14
                wrapMode: Text.Wrap
                verticalAlignment: Text.AlignVCenter
                color: "#1d2945"
                font.pixelSize: 20
                font.weight: Font.DemiBold
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 14
            color: "#0f172a"
            border.color: "#223156"

            TextArea {
                id: codeEditor
                anchors.fill: parent
                anchors.margins: 10
                placeholderText: "Введите код..."
                color: "#d8e5ff"
                placeholderTextColor: "#8ca2d1"
                font.family: "Fira Code"
                font.pixelSize: 16
                wrapMode: TextEdit.NoWrap
                background: Rectangle {
                    color: "transparent"
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
                color: parent.down ? "#3f49bf" : parent.hovered ? "#5863d8" : "#4a56c8"
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
            color: "#1d2945"
            wrapMode: Text.Wrap
            font.pixelSize: 15
        }
    }
}
