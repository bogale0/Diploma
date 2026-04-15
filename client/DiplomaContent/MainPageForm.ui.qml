/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ColumnLayout {
    property alias stack: content

    Row {
        spacing: 10
        padding: 10

        Repeater {
            model: [
                {name: "Языки", page: "LanguagesListPage.qml"},
                {name: "Курсы", page: "CourseListPage.qml"},
                {name: "Прогресс", page: "ProgressPage.qml"}
            ]

            Button {
                text: modelData.name
                Layout.fillWidth: true

                Connections {
                    onClicked: content.replace(modelData.page)
                }
            }
        }
    }

    StackView {
        id: content
        Layout.fillWidth: true
        Layout.fillHeight: true
        initialItem: ListPage {}
    }
}
