import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: jockrImage
    property alias source: photo.source
    property bool selectionActivated: false
    property bool highlighted: false

    onSelectionActivatedChanged: {
        if (!selectionActivated) {
            photo.width = width
            photo.height = height
            highlighted = false
        }
    }

    signal click()
    signal removeSelection()
    signal addSelection()

    Image {
        id: photo
        anchors.centerIn: parent
        width: parent.width
        height: parent.height

        asynchronous: true
        fillMode: Image.PreserveAspectCrop

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (jockrImage.selectionActivated) {
                    if (jockrImage.highlighted) {
                        photo.width = jockrImage.width
                        photo.height = jockrImage.height
                        jockrImage.highlighted = false
                        jockrImage.removeSelection()
                    }
                    else {
                        photo.width = photo.width - (Theme.paddingLarge * 2)
                        photo.height = photo.height - (Theme.paddingLarge * 2)
                        jockrImage.highlighted = true
                        jockrImage.addSelection()
                    }
                }
                else {
                    jockrImage.click()
                }
            }
        }
    }
}
