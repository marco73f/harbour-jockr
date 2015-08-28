import QtQuick 2.1
import harbour.jockr 1.0
import "models"
import "delegates"

Item{
    id: page

    //property var modelInterfaceContactsPhotos: ConnMan.getModelInterface(photosGetContactsPhotosModel.api)
    //property var modelInterfaceContactsPhotos: ConnMan.getModelInterface(photosGetContactsPhotosModel.api)

    Connections {
        target: Requestor

        onXmlReady: {
            photosGetContactsPhotosModel.xml = xmlResponse
        }

        onFailed: {
            photosGetContactsPhotosModel.xml = ""
        }
    }

    PhotosGetContactsPhotosModel { id: photosGetContactsPhotosModel }

    signal thumbnailClicked( string photoId, url photoUrl, string owner )

    width: parent.width
    height: parent.height

    Rectangle {
        color:"black"
        anchors.fill: parent
    }

   PathView{
       anchors.fill: parent
       delegate: TimelineDelegate{}
       model: photosGetContactsPhotosModel
       clip: true
       flickDeceleration: 1000
       highlight: Rectangle{ color: "white"; border.color: "black" }
       focus:  true

       path: Path{

        startX: parent.width / 2
        startY: parent.height / 2
        PathAttribute { name: "scale"; value: 1}
        PathAttribute { name: "z"; value: 4}
        PathAttribute { name: "opacity"; value: 1}
        PathAttribute { name: "angle"; value: 0}

        PathLine{ x: parent.width / 2; y: parent.height / 2 -1}
        PathPercent{ value: 0.03}
        PathAttribute { name: "scale"; value: 0.7}
        PathAttribute { name: "z"; value: 3}
        PathAttribute { name: "opacity"; value: 0.8}
        PathAttribute { name: "angle"; value: Math.random() * 45}

        PathQuad{ x: parent.width / 2; y: parent.height / 2 - 200; controlX:  parent.width / 2 + 100; controlY: parent.height / 2 }
        PathPercent{ value: 0.1}
        PathAttribute { name: "scale"; value: 0.5 }
        PathAttribute { name: "z"; value: 2}
        PathAttribute { name: "opacity"; value: 0.7}
        PathAttribute { name: "angle"; value: (Math.random() * -32)}

        PathQuad{ x: parent.width / 2; y: parent.height / 2 + 280; controlX:  parent.width / 2 - 200; controlY: parent.height / 2 }
        PathAttribute { name: "scale"; value: 0.4 }
        PathAttribute { name: "z"; value: 1}
        PathPercent{ value: 0.3}
        PathAttribute { name: "opacity"; value: 0.6}
        PathAttribute { name: "angle"; value: (Math.random() * 45)}

        PathQuad{ x: parent.width / 2; y: parent.height / 2 - 350; controlX:  parent.width / 2 + 400; controlY: parent.height / 2 }
        PathAttribute { name: "scale"; value: 0.4 }
        PathAttribute { name: "z"; value: 1}
        PathPercent{ value: 0.5}
        PathAttribute { name: "opacity"; value: 0.55}
        PathAttribute { name: "angle"; value: (Math.random() * -20)}

        PathQuad{ x: parent.width / 2; y: parent.height / 2 + 400; controlX:  parent.width / 2 - 400; controlY: parent.height / 2 }
        PathAttribute { name: "scale"; value: 0.5 }
        PathAttribute { name: "z"; value: 0}
        PathAttribute { name: "opacity"; value: 0.5}
        PathAttribute { name: "angle"; value: (Math.random() * -45)}
        PathPercent{ value: 0.8}

        PathQuad{ x: parent.width; y: parent.height; controlX:  parent.width / 2; controlY: parent.height / 2 }
        PathAttribute { name: "scale"; value: 0.8 }
        PathAttribute { name: "z"; value: 3}
        PathAttribute { name: "opacity"; value: 0.7}
        PathAttribute { name: "angle"; value: (Math.random() * 25)}
        PathPercent{ value: 1}

       }
   }

   Item{
       anchors.fill: parent
       visible:  photosGetContactsPhotosModel.xml == ""
        Loading{
            id: loader
            anchors.centerIn: parent
        }
   }

}

