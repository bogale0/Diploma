import QtQuick
import Diploma

AuthorizationForm {
    property int user_id

    signal loginSuccess()

    actionBtn.onClicked: {
        let method;
        switch (authMode) {
        case Constants.loginMode:
            method = "/login.php";
            break;
        case Constants.signupMode:
            method = "/signup.php";
            break;
        }
        let xhr = new XMLHttpRequest();
        xhr.open("POST", Constants.endpoint + method);
        xhr.setRequestHeader("Content-Type", "application/json");
        xhr.onload = function() {
            if (xhr.status >= 200 && xhr.status < 300) {
                let response = JSON.parse(xhr.responseText);
                user_id = response["user_id"];
                loginSuccess();
            } else {
                errText.text = xhr.responseText;
            }
        }
        xhr.send(JSON.stringify({
            name: loginText.text,
            password: pswdText.text
        }));
    }

    toggleLink.onClicked: {
        let tmp = toggleLinkText.text;
        toggleLinkText.text = actionBtn.text;
        actionBtn.text = tmp;
        if (authMode === Constants.loginMode) {
            authMode = Constants.signupMode;
        } else {
            authMode = Constants.loginMode;
        }
    }
}
