import QtQuick 2.1
import Jockr 1.0
import "../"

Item{
    id: photoDelegate
    width: parent.width
    height: parent.height
    state:  ""

    function addOrRemoveFavorite()
    {
        console.log( "AddOrRemoveFavorite: is fave:" + isfavorite == 0?"true":"false" +"," +id);

        if ( isfavorite == 0 ){
            flickrManager.addFavorite(id);
        }else{
            flickrManager.removeFavorite(id)
        }
    }

    function addComment()
    {
        console.log("addCOmment");
        if ( photoDelegate.state != "addComment"){
            addCommentView.photoId = id;
            photoDelegate.state = "addComment";
        }else{
            photoDelegate.state = "";
        }
    }

    function showComments()
    {
        if ( photoDelegate.state != "showComments"){
            flickrManager.getComments(id);
            photoDelegate.state = "showComments";
        }else{
            photoDelegate.state = "";
        }
    }

    function showInfo()
    {
        if ( photoDelegate.state != "showInfo"){
            photoDelegate.state = "showInfo";
        }else{
            photoDelegate.state = "";
        }
    }

    // Main image
    Image{
        id: photo
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent
        smooth: true
        source: "https://farm"+farm+".staticflickr.com/"+server+"/"+id+"_"+secret+"_z.jpg"
        onSourceChanged: opacity = 0;
        onStatusChanged: { (status == Image.Ready)?opacity = 1:opacity = 0 }
        Behavior on opacity { PropertyAnimation { duration: 500 } }

        MouseArea{
            anchors.fill: parent
            onClicked: showInfo();
        }

        /*
        GestureArea{
            onTap: showInfo();
            onPinch: {photo.scale = gesture.scaleFactor; photo.rotation = gesture.rotationAngle; }
            //console.log("pinch center = (",gesture.centerPoint.x,",",gesture.centerPoint.y,") rotation =",gesture.rotationAngle," scale =",gesture.scaleFactor)
        }
        */
    }

    Loading{
        anchors.centerIn: photo
        visible: photo.opacity < 1
    }

    Rectangle{
        id: detailsBg
        anchors.fill: parent
        color: "black"
        opacity: 0
    }

    // Title bar on top
    Item{
        id: titleBar
        height: childrenRect.height
        anchors.bottom: photoDelegate.top
        anchors.bottomMargin: Theme.paddingMedium
        anchors.left: photo.left
        anchors.right: photo.right
        opacity: 0

        MouseArea{
            anchors.fill: parent
            onClicked: console.log("TODO: Implement showing user's photostream")
        }

        // Placeholder for a graphics
        Rectangle{
            id: titleBarBg
            anchors.fill: parent
            anchors.rightMargin: Theme.paddingMedium
            color: "#00000000"
        }

        Text{
            id: titleText
            text: title
            color: "white"
            smooth: true
            anchors.top: titleBar.top
            anchors.left: titleBar.left
            anchors.right: titleBar.right
            anchors.leftMargin: Theme.paddingMedium
            height: paintedHeight
            elide: Text.ElideRight
        }

        Text{
            id: author
            text: "by " + username
            color: "white"
            smooth: true
            anchors.top: titleText.bottom
            anchors.left: titleText.left
            anchors.right: titleText.right
            anchors.rightMargin: Theme.paddingMedium
            height: paintedHeight
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignLeft
        }

        FlickrText{
            id: viewsText
            header: "Views"
            text: views
            anchors.top: author.bottom
            anchors.left: author.left
            anchors.topMargin: Theme.paddingMedium
        }
        FlickrText{
            id: commentsText
            header: "Comments"
            text: comments
            anchors.top: viewsText.top
            anchors.left: viewsText.right
            anchors.leftMargin: Theme.paddingMedium
        }
        FlickrText{
            id: dateText
            header: "Date"
            text: datetaken
            anchors.top: viewsText.bottom
            anchors.left: viewsText.left
        }
        Rectangle {
            color: "white"
            anchors.top:  dateText.bottom
            height: 3
            //anchors.horizontalCenter: parent.horizontalCenter
            anchors.left: parent.left
            anchors.right: parent.right
        }
    }
    // End of the title bar


    // Description area in the middle
    Item{
        id: descriptionArea
        anchors.top: titleBar.bottom
        anchors.bottom: bottomBar.top
        anchors.left: photo.right

        // Placeholder for a graphics
        Rectangle{
            id: descriptionAreaBg
            anchors.fill: parent
            color: "black"
            opacity: 0.8
            visible: false
        }
        Flickable{
            id: flickableDescriptionText
            anchors.fill: descriptionAreaBg
            contentHeight: descriptionText.paintedHeight
            clip:  true
            Text{
                id: descriptionText
                y: Theme.paddingMedium
                text: {if (description != "" )return description; else return "No Description"; }
                width: parent.width
                wrapMode: Text.Wrap
                smooth:  true
                color: "white"
                opacity: 1
                clip: true
                textFormat: Text.RichText
                onLinkActivated:Qt.openUrlExternally(link)
            }
        }
    }
    // End of the description area


    // Bottom bar at the bottom
    Item{
        id: bottomBar
        anchors.top: photoDelegate.bottom
        anchors.left: photoDelegate.left
        anchors.right: photoDelegate.right
        height: favoriteButton.height + 2*Theme.paddingMedium

        // Placeholder for graphics
        Rectangle{
            id: bottomBarBg
            anchors.fill: parent
            color: "#00000000"
        }

        Row{
            anchors.centerIn: bottomBarBg
            anchors.leftMargin: Theme.paddingMedium
            anchors.rightMargin: Theme.paddingMedium
            spacing:  (parent.width-Theme.paddingMedium*2-favoriteButton.width*4) /3

            RadioButton{
                id: favoriteButton
                //checkedIconSource: "qrc:///gfx/favorite-on.png"
                //uncheckedIconSource: "qrc:///gfx/favorite-off.png"
                checked: isfavorite == "1"
                onClicked: addOrRemoveFavorite();
            }

            ToolButton{
                id: descriptionButton
                iconSource: enabled ? "qrc:/qml/flickr-qtquick/gfx/description.png" : "qrc:/qml/flickr-qtquick/gfx/comments.png"
                //enabledIconSource: "qrc:/qml/flickr-qtquick/gfx/description.png"
                //disabledIconSource: "qrc:///gfx/comments.png"
                enabled: true
                onClicked: showInfo();
            }

            ToolButton {
                id: commentsButton
                iconSource: enabled ? "qrc:/qml/flickr-qtquick/gfx/comments-active.png" : "qrc:/qml/flickr-qtquick/gfx/comments.png"
                //enabledIconSource: "qrc:///gfx/comments-active.png"
                //disabledIconSource: "qrc:///gfx/comments.png"
                enabled: comments != "0"
                onClicked: showComments();
            }
            ToolButton {
                id: addCommentsButton
                iconSource: "qrc:/qml/flickr-qtquick/gfx/comments-add.png"
                //enabledIconSource: "qrc:///gfx/comments-add.png"
                onClicked: addComment();
            }
        }
    }
    // End of the bottom bar


    // Comment field
    PhotosCommentsGetList {
        id: commentsView
        anchors.top: titleBar.bottom
        anchors.bottom: bottomBar.top
        anchors.left: photo.right
        photoId: id
    }
    // end of comment field

    // Add Comment Field
    PhotosCommentsAdd {
        id: addCommentView
        anchors.top: titleBar.bottom
        anchors.bottom: bottomBar.top
        anchors.left: photo.right
        //onCommentAdded: {photoDelegate.state = ""; updateInfo.start()}

    }
    // end of add comment field


    Timer {
        id: updateInfo
         interval: 500;
         onTriggered: flickrManager.getPhotoInfo( id );
    }


    states: [
        State {
            name: "superState"
            AnchorChanges {
                target: titleBar
                anchors.bottom: undefined
                anchors.top: photo.top
            }
            AnchorChanges {
                target: bottomBar
                anchors.top: undefined
                anchors.bottom: photo.bottom
            }
        },

        State {
            name: "showInfo"
            //extend: "superState"
            AnchorChanges {
                target: titleBar
                anchors.bottom: undefined
                anchors.top: photo.top
            }
            PropertyChanges {
                target: titleBar
                opacity: 1
            }

            AnchorChanges {
                target: bottomBar
                anchors.top: undefined
                anchors.bottom: photo.bottom
            }
            PropertyChanges{
                target: detailsBg
                opacity: 0.8
            }
            AnchorChanges{
                target: descriptionArea
                anchors.top: titleBar.bottom
                anchors.bottom: bottomBar.top
                anchors.left: photo.left
                anchors.right: photo.right
            }
        },
        State{
            name:  "showComments"
            //extend: "superState"
            AnchorChanges {
                target: titleBar
                anchors.bottom: undefined
                anchors.top: photo.top
            }
            AnchorChanges {
                target: bottomBar
                anchors.top: undefined
                anchors.bottom: photo.bottom
            }
            PropertyChanges{
                target: detailsBg
                opacity: 0.8
            }
            PropertyChanges {
                target: titleBar
                opacity: 1
            }
            AnchorChanges {
                target: descriptionArea
                anchors.left: photo.right
                anchors.right: undefined
            }
            AnchorChanges {
                target: commentsView
                anchors.left: photo.left
                anchors.right: photo.right
            }
        },
        State{
            name:  "addComment"
            //extend: "superState"
            AnchorChanges {
                target: titleBar
                anchors.bottom: undefined
                anchors.top: photo.top
            }
            AnchorChanges {
                target: bottomBar
                anchors.top: undefined
                anchors.bottom: photo.bottom
            }
            PropertyChanges{
                target: detailsBg
                opacity: 0.8
            }
            PropertyChanges {
                target: titleBar
                opacity: 1
            }
            AnchorChanges {
                target: descriptionArea
                anchors.left: photo.right
                anchors.right: undefined
            }
            AnchorChanges {
                target: addCommentView
                anchors.left: photo.left
                anchors.right: photo.right
            }
        }

    ]

    transitions: [
        Transition{
            AnchorAnimation{ duration: 500; easing.type: Easing.InOutExpo }
            PropertyAnimation{ duration: 500; properties: "visible,opacity" }
        }

    ]

    onStateChanged: console.log("New State:" + state)

}
