import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: jockrImage
    property alias source: photo.source

    signal click()

    Image {
        id: photo
        anchors.fill: parent
        asynchronous: true
        fillMode: Image.PreserveAspectCrop

        MouseArea {
            anchors.fill: parent
            onClicked: jockrImage.click()
        }
    }
}
