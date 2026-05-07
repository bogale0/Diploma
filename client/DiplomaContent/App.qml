import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import Diploma 1.0
import Backend 1.0

Window {
    id: appWindow
    width: maximumWidth
    height: maximumHeight
    minimumWidth: 1024
    minimumHeight: 576
    visible: true
    color: Constants.backgroundColor
    title: "Школа программирования"
    flags: Qt.Window | Qt.FramelessWindowHint

    function openProfileLikeNav() {
        if (stack.depth > 1)
            stack.pop()
        mainPage.navigationRequest(mainPage.profilePageId, {})
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            id: customTitleBar
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            color: "#dce9ff"

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 1
                color: "#a9bddf"
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 8
                spacing: 10

                Image {
                    Layout.fillHeight: true
                    Layout.preferredWidth: height
                    Layout.alignment: Qt.AlignVCenter
                    smooth: true
                    source: "images/icon.png"
                }

                Item {
                    id: dragStrip
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Label {
                        anchors.centerIn: parent
                        text: appWindow.title
                        color: "#16345f"
                        font.pixelSize: 18
                        font.weight: Font.DemiBold
                        elide: Text.ElideRight
                        horizontalAlignment: Text.AlignHCenter
                    }

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton
                        onPressed: function (mouse) {
                            mouse.accepted = true
                            appWindow.startSystemMove()
                        }
                    }
                }

                RowLayout {
                    spacing: 4
                    Layout.alignment: Qt.AlignVCenter

                    ToolButton {
                        id: profileHeaderButton
                        implicitWidth: 44
                        implicitHeight: 44
                        flat: true
                        hoverEnabled: true

                        background: Rectangle {
                            radius: 10
                            color: parent.down ? "#9eb9e8" : parent.hovered ? "#b2ccfb" : "transparent"
                        }

                        contentItem: Text {
                            anchors.fill: parent
                            text: "👤"
                            font.pixelSize: 22
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: appWindow.openProfileLikeNav()
                    }

                    ToolButton {
                        id: closeHeaderButton
                        implicitWidth: 44
                        implicitHeight: 44
                        flat: true
                        hoverEnabled: true

                        background: Rectangle {
                            radius: 10
                            color: parent.down ? "#e07a7a" : parent.hovered ? "#f0a8a8" : "transparent"
                        }

                        contentItem: Text {
                            anchors.fill: parent
                            text: "\u2715"
                            font.pixelSize: 20
                            font.weight: Font.Medium
                            color: "#16345f"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: Qt.quit()
                    }
                }
            }
        }

        StackView {
            id: stack
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            initialItem: MainPage {
                id: mainPage
                onOpenAuthRequested: function(pageId, properties) {
                    var authPage = stack.push("Authorization.qml", {
                        "redirectPageId": pageId,
                        "redirectProperties": properties
                    })
                    authPage.authCompleted.connect(function(redirectPageId, redirectProperties) {
                        stack.pop()
                        var effectivePageId = redirectPageId
                        if (Api.userRole === "teacher" && redirectPageId === mainPage.profilePageId) {
                            effectivePageId = mainPage.teacherPageId
                        }
                        mainPage.navigationRequest(effectivePageId, redirectProperties)
                    })
                }
                onOpenTeacherRequested: {
                    var teacherPage = stack.push("TeacherMainPage.qml")
                    teacherPage.loggedOut.connect(function() {
                        stack.clear()
                        stack.push(mainPage)
                        mainPage.navigationRequest(mainPage.languagesPageId, null)
                    })
                }
            }
        }
    }

    Rectangle {
        id: splashLayer
        anchors.fill: parent
        z: 10
        color: "transparent"
        SplashScreen {
            anchors.fill: parent
            onFinished: splashLayer.visible = false
        }
    }
}
