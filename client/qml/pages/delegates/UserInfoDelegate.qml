import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle{
    anchors.fill: parent
    color: "black"
    width:  parent.width

    Image{
        id: buddyIcon
        source: "https://farm"+iconfarm+".staticflickr.com/"+iconserver+"/buddyicons/"+nsid+".jpg"
        width: 48
        height: 48
        anchors.top:  parent.top
        anchors.topMargin: Theme.paddingMedium
        anchors.right: parent.right
        anchors.rightMargin: Theme.paddingMedium
    }
    Text{
        id: userName
        text: username
        color: "white"
        verticalAlignment: Text.AlignTop
        smooth: true
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: Theme.paddingMedium
        anchors.right: parent.right
        width: parent.width - buddyIcon.width - Theme.paddingMedium*2
        elide: Text.ElideRight
        Component.onCompleted: console.log("xxx"+width)
    }

    FlickrText{
        id: photos
        header:  "Photos"
        text: count
        anchors.top: userName.bottom
        anchors.left: parent.left
        anchors.leftMargin: Theme.paddingMedium
    }

    FlickrText{
        id: pro
        header: "Pro"
        text: (ispro != 0?"yes":"no")
        anchors.top: photos.bottom
        anchors.topMargin: Theme.paddingMedium
        anchors.left: photos.left
    }

    FlickrText{
        id: dateTaken
        header: "First upload"
        text: firstdatetaken // TODO: format this to shorter
        anchors.top:  pro.bottom
        anchors.topMargin: Theme.paddingMedium
        anchors.left: pro.left
    }
    FlickrText{
        id: location
        header:  "Location"
        text: (geolocation != ""? geolocation:"unknown")
        anchors.top:  dateTaken.bottom
        anchors.topMargin: Theme.paddingMedium
        anchors.left: dateTaken.left
    }
}
