import QtQuick

MainPageForm {
    Component.onCompleted: stack.currentItem.errText.text = user_id;
}
