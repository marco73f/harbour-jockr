
import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: jockrImage
    property alias source: photo.source
    property string photosetId
    property alias albumTitle: lTitle.text

    signal click()

    Image {
        id: photo
        anchors.top: parent.top

        width: jockrImage.width
        height: jockrImage.height - lTitle.height - (Theme.paddingSmall * 2)

        asynchronous: true
        fillMode: Image.PreserveAspectCrop

        MouseArea {
            anchors.fill: parent
            onClicked: jockrImage.click()
        }
    }

    Label {
        id: lTitle
        width: jockrImage.width
        anchors {
            bottom: parent.bottom
            bottomMargin: Theme.paddingSmall
            horizontalCenter: parent.horizontalCenter
        }
        fontSizeMode: Theme.fontSizeExtraSmall
        truncationMode: TruncationMode.Fade
    }
}
