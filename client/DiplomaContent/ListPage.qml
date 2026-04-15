import QtQuick
import Backend 1.0

ListPageForm {
    readonly property int langItems: 1
    required property int itemsType

    Component.onCompleted: {
        switch (itemsType) {
        case langItems:
            Api.getLanguages();
            break;
        }
    }
}
