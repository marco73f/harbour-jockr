import QtQuick 2.0
import Sailfish.Silica 1.0

// icon-m-people.png icon-l-people.png icon-cover-people.png

BackgroundItem {
    id: rowItem
    property alias placeHolderIcon: placeHolder.source
    property alias sourceIcon: buddyIcon.source
//    property alias stateIcon: buddyItem.state
    property alias tabLabel: tabLabel.text
    property alias numberItem: numberLabel.text

    Row {
        id: buddyItem

        anchors.fill: parent

        spacing: Theme.paddingLarge

        state: "loading"

        Label {
            id: numberLabel
            width: rowItem.height
            anchors.verticalCenter: parent.verticalCenter
            color: parent.down ? Theme.highlightColor : Theme.primaryColor
            horizontalAlignment: Text.AlignRight
        }

        Item {
            id: borderImg
            anchors.verticalCenter: parent.verticalCenter
            width: rowItem.height
            height: rowItem.height

            Image {
                id: placeHolder
                anchors.centerIn: parent
                width: parent.width // Size is defined by Flickr
                height: parent.height
                asynchronous: true
                fillMode: Image.Stretch
            }

            Image{
                id: buddyIcon
                anchors.centerIn: parent
                width: parent.width // Size is defined by Flickr
                height: parent.height
                asynchronous: true
                fillMode: Image.PreserveAspectCrop
            }
        }

        Label {
            id: tabLabel
            anchors.verticalCenter: parent.verticalCenter
            color: parent.down ? Theme.highlightColor : Theme.primaryColor
        }

        states: [
            State {
                name: "loading" //; when: buddyIcon.status == Image.Error
                PropertyChanges { target: placeHolder; visible: true }
                PropertyChanges { target: buddyIcon; visible: false }
            },
            State {
                name: "loaded"; when: buddyIcon.status == Image.Ready
                PropertyChanges { target: placeHolder; visible: false }
                PropertyChanges { target: buddyIcon; visible: true }
            }
        ]
    }
}
