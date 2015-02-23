import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: pageViewer
    allowedOrientations: Orientation.All
    property alias sourceImage: image.source

    Flickable {
        id: flickable
        anchors.fill: parent
        clip: true
        contentWidth: imageContainer.width
        contentHeight: imageContainer.height

        Item {
            id: imageContainer
            anchors.centerIn: parent
            width: Math.max(image.width * image.scale, flickable.width)
            height: Math.max(image.height * image.scale, flickable.height)

            Image {
                id: image
                property real prevScale
                anchors.centerIn: parent
                smooth: !flickable.movingVertically && !flickable.movingHorizontally
                sourceSize.width: pageViewer.width

                fillMode: Image.PreserveAspectFit
                asynchronous: true

                PinchArea {
                    anchors.fill: parent
                    pinch.target: parent
                    pinch.minimumScale: 1
                    pinch.maximumScale: 6
                }
            }
        }
    }
}



