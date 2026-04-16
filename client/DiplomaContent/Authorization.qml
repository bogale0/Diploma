import QtQuick
import Backend 1.0

AuthorizationForm {
    property int authRequestId

    Connections {
        target: Api

        function onApiError(err) {
            errText = err;
        }

        function onAuthSuccess() {
            authSuccess();
        }
    }

    authButton.onClicked: Api.auth(login, password, authMode)
}
