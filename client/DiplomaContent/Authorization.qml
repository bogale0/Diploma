import QtQuick
import Backend 1.0

AuthorizationForm {
    Connections {
        target: Api

        function onAuthSuccess() {
            authSuccess();
        }

        function onNetworkError(err) {
            errText = err;
        }
    }

    authButton.onClicked: Api.auth(login, password, authMode)
}
