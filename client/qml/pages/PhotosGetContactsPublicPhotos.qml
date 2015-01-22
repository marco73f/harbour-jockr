import QtQuick 2.0
import Sailfish.Silica 1.0
import Jockr 1.0
import "models"
import "delegates"

Page {
    id: page

    Connections {
        target: Requestor

        onXmlReady: {
            photosGetContactsPublicPhotosModel.xml = xmlResponse
        }

        onFailed: {
            photosGetContactsPublicPhotosModel.xml = ""
        }
    }

    PhotosGetContactsPublicPhotosModel { id: photosGetContactsPublicPhotosModel }

    signal thumbnailClicked( string photoId, url photoUrl, string owner )

    width: parent.width
    height: parent.height

    SilicaGridView {
        id: grid
        header: PageHeader { title: qsTr("Images") }
        cellWidth: width / 2
        cellHeight: width / 2
        anchors.fill: parent
        model: photosGetContactsPublicPhotosModel

        delegate: Item {
            width: grid.cellWidth
            height: grid.cellHeight
            clip: true
            Image {
                id: thumb
                anchors.fill: parent
                asynchronous: true
                scale: 0.0
                Behavior on scale { NumberAnimation { easing.type: Easing.InOutQuad } }
                source: "https://farm" + farm + ".staticflickr.com/" + server + "/" + id + "_" + secret + "_m.jpg"

                MouseArea {
                    anchors.fill: parent
                    onClicked: window.pageStack.push(Qt.resolvedUrl("FlickrSlideView.qml"), {currentIndex: index, model: grid.model} )
                }

                states: [
                    State {
                        name: "Show"; when: thumb.status == Image.Ready
                        PropertyChanges { target: thumb; scale: 1 }
                    }
                ]
            }
        }
        ScrollDecorator {}
    }
}

