import QtQuick
import QtQuick.Controls
import Diploma 1.0
import Backend 1.0

Window {
    width: maximumWidth
    height: maximumHeight
    minimumWidth: 1024
    minimumHeight: 576
    visible: true
    color: Constants.backgroundColor
    title: "Школа программирования"

    StackView {
        id: stack
        anchors.fill: parent
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
            onOpenTeacherRequested: stack.push("TeacherMainPage.qml")
        }
    }
}
