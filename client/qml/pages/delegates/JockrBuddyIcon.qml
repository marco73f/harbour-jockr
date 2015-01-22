import QtQuick 2.0
import Sailfish.Silica 1.0

Row {
    id: buddyItem
    anchors {
        fill: parent
        margins: Theme.paddingLarge
    }

    property string iconFarm
    property string iconServer
    property string nsId
    property alias userName: userName.text
    property alias realName: realName.text
    property color clr

    state: "loading"

    spacing: Theme.paddingLarge

    Rectangle {
        id: borderImg
        anchors.verticalCenter: parent.verticalCenter
        width: buddyIcon.width + Theme.paddingSmall
        height: buddyIcon.height + Theme.paddingSmall
        color: Theme.highlightColor

        Image {
            id: placeHolder
            anchors.centerIn: parent
            width: 64 // Size is defined by Flickr
            height: 64
            asynchronous: true
            source: "image://theme/icon-cover-people"
        }

        Image{
            id: buddyIcon
            anchors.centerIn: parent
            asynchronous: true
            source: "https://farm" + buddyItem.iconFarm + ".staticflickr.com/" + buddyItem.iconServer + "/buddyicons/" + buddyItem.nsId + ".jpg";
            width: 64 // Size is defined by Flickr
            height: 64
        }
    }

    Column {
        anchors.verticalCenter: parent.verticalCenter

        Label {
            id: userName
            elide: Text.ElideRight
            color: buddyItem.clr
        }

        Label {
            id: realName
            elide: Text.ElideRight
            font.pixelSize: Theme.fontSizeExtraSmall
            color: buddyItem.clr
        }
    }

    states: [
        State {
            name: 'loading' //; when: buddyIcon.status == Image.Error
            PropertyChanges { target: placeHolder; visible: true }
            PropertyChanges { target: buddyIcon; visible: false }
        },
        State {
            name: 'loaded'; when: buddyIcon.status == Image.Ready
            PropertyChanges { target: placeHolder; visible: false }
            PropertyChanges { target: buddyIcon; visible: true }
        }
    ]
}
