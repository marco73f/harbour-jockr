import QtQuick 2.0

Item{
    property alias source: image.source
    property alias clip: image.clip
    property alias fillMode: image.fillMode
    property alias smooth: image.smooth
    property alias sourceSize: image.sourceSize
    property bool showBorder: true
    property bool showLoader: true
    property int  borderWidth: 2
    signal clicked
    signal pressAndHold
    smooth: true

    Rectangle {
        id: background
        anchors.fill: parent
        color: "black"
        border.width: showBorder? borderWidth:0
        border.color: showBorder?"white":color
        smooth: true
        scale:  0
        Image{
            id: image
            anchors.fill: parent
            smooth: true
            anchors.topMargin: background.border.width
            anchors.bottomMargin: background.border.width
            anchors.leftMargin: background.border.width
            anchors.rightMargin: background.border.width

        }

        Loading{
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            visible: showLoader && (image.status != Image.Ready)
        }
    }


    MouseArea{
        anchors.fill: parent
        onClicked: parent.clicked();
        onPressAndHold: parent.pressAndHold();
    }

    states: [
        State {
            name: "Show";
            when: image.status == Image.Ready
            PropertyChanges { target: background; scale: 1 }
        }
    ]

    transitions: [
        Transition {
            PropertyAnimation {
                properties: "scale"
                easing.type: "OutCubic"
                duration: 500
            }
        }
    ]

}
