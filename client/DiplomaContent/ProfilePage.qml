import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Backend 1.0

Item {
    signal loggedOut()
    property int overallProgress: 0
    property var courses: []

    Component.onCompleted: Api.getProgress()

    Rectangle { anchors.fill: parent; color: "#f3f8ff" }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 14

        Label { text: "Личный кабинет"; font.pixelSize: 36; font.weight: Font.Bold; color: "#16345f" }
        Label { text: "Общий прогресс: " + overallProgress + "%"; color: "#234877"; font.pixelSize: 24 }

        Label { text: "Курсы"; font.pixelSize: 24; color: "#16345f" }
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ColumnLayout {
                width: parent.width
                spacing: 10

                Repeater {
                    model: courses
                    delegate: Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 92
                        radius: 14
                        color: "#e8f1ff"
                        border.color: "#9cb5db"

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 6

                            Label {
                                text: modelData.text
                                color: "#16345f"
                                font.pixelSize: 24
                                font.weight: Font.DemiBold
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 10

                                ProgressBar {
                                    Layout.fillWidth: true
                                    from: 0
                                    to: 100
                                    value: modelData.progress_percent
                                }

                                Label {
                                    text: modelData.completed_lessons + "/" + modelData.total_lessons
                                    color: "#234877"
                                    font.pixelSize: 18
                                }
                            }
                        }
                    }
                }
            }
        }

        Button {
            text: "Выйти из аккаунта"
            Layout.fillWidth: true
            onClicked: {
                Api.logout()
                loggedOut()
            }
        }
    }

    Connections {
        target: Api
        function onProgressReceived(data) {
            overallProgress = data.overall_progress
            courses = data.courses
        }
    }
}
