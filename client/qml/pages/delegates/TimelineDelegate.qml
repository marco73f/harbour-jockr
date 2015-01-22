import QtQuick 2.0

Rectangle{
    id: polaroid
    transform: Rotation {
        origin.x: width / 2;
        origin.y: height / 2;
        axis { x: 0; y: 0; z: 1 }
        angle: PathView.angle //if (index % 2 == 0) PathView.angle * -1; else PathView.angle;
    }
    scale: PathView.scale
    z: PathView.z
    width: 230
    height: 270//250
    color: "white"
    smooth:  true
    //source: "qrc:/gfx/polaroid-bg.png"

    Image{
        id: image
        anchors.top:    parent.top
        anchors.topMargin: Theme.paddingMedium
        anchors.left:   parent.left
        anchors.leftMargin: Theme.paddingMedium
        anchors.right:  parent.right
        anchors.rightMargin: Theme.paddingMedium
        anchors.bottom: parent.bottom
        anchors.bottomMargin: author.paintedHeight * 2
        source: "https://farm"+farm+".staticflickr.com/"+server+"/"+id+"_"+secret+"_m.jpg"
        smooth: true
        fillMode: Image.PreserveAspectCrop
        clip:  true

        MouseArea{
            anchors.fill: parent
            onClicked: timelineView.thumbnailClicked(id, image.source, owner);
        }

    }

    // Black rectangle for polaroid effect
    Rectangle{
        anchors.fill: image

        gradient: Gradient {
             GradientStop { position: 0.0; color: "black" }
             GradientStop { position: 0.5; color: "darkGray" }
             GradientStop { position: 1.0; color: "black" }
           }
        smooth:  true
        opacity:  1
        visible: opacity > 0
        NumberAnimation on opacity{
            to: 0
            duration: 1000
            running: image.status == Image.Ready
        }
    }

    Text{
        id: author
        anchors.top: image.bottom
        anchors.left: image.left
        anchors.right: image.right
        anchors.bottom: polaroid.bottom
        color: "black"
        text: "by " + username
        elide: Text.ElideRight
    }
}
