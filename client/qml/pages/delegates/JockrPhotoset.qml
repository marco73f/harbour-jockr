
import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: jockrImage
    property alias source: photo.source
    property string photosetId
    property alias albumTitle: lTitle.text
    property bool highlighted: false
    property bool editMode

    onEditModeChanged: {
        if (!editMode) {
            photo.width = width
            photo.height = height - lTitle.height - (Theme.paddingSmall * 2)
            highlighted = false
        }
    }

    signal click()
    signal removeSelection(string photo_id)
    signal addSelection(string photo_id)

    Image {
        id: photo
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }

        width: jockrImage.width
        height: jockrImage.height - lTitle.height - (Theme.paddingSmall * 2)

        asynchronous: true
        fillMode: Image.PreserveAspectCrop

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (jockrImage.editMode) {
                    if (jockrImage.highlighted) {
                        photo.width = jockrImage.width
                        photo.height = jockrImage.height - lTitle.height - (Theme.paddingSmall * 2)
                        jockrImage.highlighted = false
                        jockrImage.removeSelection(jockrImage.photosetId)
                    }
                    else {
                        photo.width = photo.width - (Theme.paddingLarge * 2)
                        photo.height = photo.height - (Theme.paddingLarge * 2)
                        jockrImage.highlighted = true
                        jockrImage.addSelection(jockrImage.photosetId)
                    }
                }
                else {
                    jockrImage.click()
                }
            }
        }
    }

    Label {
        id: lTitle
        width: jockrImage.width
        color: jockrImage.highlighted ? Theme.highlightColor : Theme.primaryColor
        anchors {
            bottom: parent.bottom
            bottomMargin: Theme.paddingSmall
            horizontalCenter: parent.horizontalCenter
        }
        fontSizeMode: Theme.fontSizeExtraSmall
        truncationMode: TruncationMode.Fade
    }
}
