import QtQuick
import Backend 1.0

AuthorizationForm {
    property int authRequestId
    property int redirectPageId: -1
    property var redirectProperties: null

    Connections {
        target: Api

        function onApiError(err) {
            errText = err;
        }

        function onAuthSuccess() {
            authSuccess();
        }
    }

    onAuthSuccess: {
        var targetPageId = redirectPageId
        var targetProperties = redirectProperties
        var appStack = StackView.view

        if (!appStack) {
            return
        }

        appStack.pop()
        Qt.callLater(function() {
            if (targetPageId >= 0 && appStack.currentItem
                    && appStack.currentItem.navigationRequest) {
                appStack.currentItem.navigationRequest(targetPageId, targetProperties)
            }
        })
    }

    authButton.onClicked: Api.auth(login, password, authMode, selectedRole)
}
