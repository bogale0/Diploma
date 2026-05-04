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

        function onPasswordRecovered() {
            recoverySuccess()
        }
    }

    onAuthSuccess: {
        authCompleted(redirectPageId, redirectProperties)
    }

    onRecoverySuccess: {
        errText = "Пароль обновлён. Теперь войдите."
        authMode = loginMode
        authButton.text = "Войти"
    }

    authButton.onClicked: {
        errText = ""
        if (authMode === signupMode) {
            Api.auth(login, password, authMode, selectedRole, recovery)
        } else if (authMode === recoveryMode) {
            if (password !== newPassword) {
                errText = "Пароли не совпадают"
                return
            }
            Api.recoverPassword(login, recovery, password)
        } else {
            Api.auth(login, password, authMode, selectedRole)
        }
    }
}
