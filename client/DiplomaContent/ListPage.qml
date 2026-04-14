import QtQuick
import Backend 1.0

ListPageForm {
    readonly property int languages: 1
    required property int itemsType

    Component.onCompleted: {
        switch (itemsType) {
        case languages:
            Api.getLanguages();
            break;
        }
    }
}
