import QtQuick 2.0

Component {
    id: photoDelegate
    Item {
        id: wrapper; width: 79; height: 79

        Item {
            anchors.centerIn: parent
            scale: 0.0
            Behavior on scale { NumberAnimation { easing.type: Easing.InOutQuad} }
            id: scaleMe

            Rectangle { height: 79; width: 79; id: blackRect;  anchors.centerIn: parent; color: "black"; smooth: true }
            Rectangle {
                id: whiteRect; width: 76; height: 76; anchors.centerIn: parent; color: "#dddddd"; smooth: true
                Image { id: thumb;
                    source: "https://farm" + farm + ".staticflickr.com/" + server + "/" + id + "_" + secret + "_m.jpg"
                    width: parent.width; height: parent.height
                    x: 1; y: 1; smooth: true}
            }

            states: [
                State {
                    name: "Show"; when: thumb.status == Image.Ready
                    PropertyChanges { target: scaleMe; scale: 1 }
                }
            ]
            transitions: [
                Transition {
                    from: "Show"; to: "Details"
                    ParentAnimation {
                        NumberAnimation { properties: "x,y"; duration: 500; easing.type: Easing.InOutQuad }
                    }
                }
            ]
        }
    }
}
