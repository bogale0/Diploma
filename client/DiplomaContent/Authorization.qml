import QtQuick
import Backend 1.0

AuthorizationForm {
    property int authRequestId

    Connections {
        target: Api

        function onApiResult(id, status, data) {
            if (status < 200 || status >= 300) {
                errText = data["error"];
            } else if (id === authRequestId) {
                Api.setBearer(data["bearer_token"])
                authSuccess();
            }
        }
    }

    authButton.onClicked: authRequestId = Api.auth(login, password, authMode)
}
