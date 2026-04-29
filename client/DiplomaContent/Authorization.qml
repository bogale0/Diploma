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
        StackView.view.pop()
        if (redirectPageId >= 0 && StackView.view && StackView.view.currentItem
                && StackView.view.currentItem.navigationRequest) {
            StackView.view.currentItem.navigationRequest(redirectPageId, redirectProperties)
        }
    }

    authButton.onClicked: Api.auth(login, password, authMode, selectedRole)
}
