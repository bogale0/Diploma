import QtQuick
import QtQuick.Controls

Item {
    id: splash
    anchors.fill: parent

    property real panelOpacity: 1
    property real emblemScale: 0.9

    signal finished()

    opacity: panelOpacity

    SequentialAnimation {
        id: entranceAnim
        PauseAnimation { duration: 40 }
        NumberAnimation {
            target: splash
            property: "emblemScale"
            from: 0.88
            to: 1.0
            duration: 640
            easing.type: Easing.OutCubic
        }
        ScriptAction {
            script: holdTimer.start()
        }
    }

    Component.onCompleted: entranceAnim.start()

    Rectangle {
        anchors.fill: parent
        color: "#dbe8ff"
        gradient: Gradient {
            GradientStop { position: 0; color: "#e8f0ff" }
            GradientStop { position: 1; color: "#c9ddf7" }
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: 22
        scale: emblemScale

        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            width: Math.min(parent.width - 96, 120)
            height: width
            fillMode: Image.PreserveAspectFit
            smooth: true
            source: "images/icon.png"
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            text: "Школа программирования"
            color: "#16345f"
            font.pixelSize: 26
            font.weight: Font.Bold
            font.letterSpacing: 0.2
        }

        Label {
            width: Math.min(implicitWidth, splash.width - 80)
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
            text: "Курсы ЯП, теория, практика и автоматические тесты в одном месте"
            color: "#2d5588"
            font.pixelSize: 15
            lineHeight: 1.25
            opacity: 0.94
        }
    }

    Timer {
        id: holdTimer
        interval: 2000
        running: false
        repeat: false
        onTriggered: fadeAnim.start()
    }

    SequentialAnimation {
        id: fadeAnim

        ParallelAnimation {
            NumberAnimation {
                target: splash
                property: "panelOpacity"
                from: 1
                to: 0
                duration: 550
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: splash
                property: "emblemScale"
                from: emblemScale
                to: emblemScale * 1.06
                duration: 550
                easing.type: Easing.OutCubic
            }
        }

        PauseAnimation { duration: 40 }

        ScriptAction {
            script: splash.finished()
        }
    }

}
