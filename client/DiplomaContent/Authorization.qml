import QtQuick
import Backend 1.0

AuthorizationForm {
    property int authRequestId
    property int redirectPageId: -1
    property var redirectProperties: null
    signal authCompleted(int pageId, var properties)

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
        authCompleted(redirectPageId, redirectProperties)
    }

    authButton.onClicked: Api.auth(login, password, authMode, selectedRole)
}
