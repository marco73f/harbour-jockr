import QtQuick 2.0
import Sailfish.Silica 1.0
import org.nemomobile.thumbnailer 1.0
import Sailfish.TransferEngine 1.0

ShareDialog {
    id: root
    allowedOrientations: Orientation.Portrait
    property string titleMedia

    width: Screen.width
    height: Screen.height

    Component.onCompleted: {
        var pathArr = path.split("/")
        var filename = pathArr[pathArr.length - 1]
        titleMedia = filename.substr(0, filename.lastIndexOf("."))
    }

    property string path: source

    property int viewWidth: root.isPortrait ? Screen.width : Screen.width / 2
    property string uploadUrl: "https://up.flickr.com/services/upload/"

    onAccepted: {
        shareItem.userData = {"title": mediaTitle.text,
            "description": mediaDesc.text + "," + //"description"
            mediaTags.text + "," + //"tags"
            (mediaType.currentIndex + 1) + "," + //"mediaType"
            (mediaPrivacy.currentIndex == 1 ? 1 : 0) + "," + //"is_friend"
            (mediaPrivacy.currentIndex == 2 ? 1 : 0) + "," + //"is_family"
            (mediaPrivacy.currentIndex == 3 ? 1 : 0) + "," + //"is_public"
            (mediaSafety.currentIndex + 1) + "," + //"safety_level"
            (mediaPublicReserch.text == "yes" ?  1 : 2)} //"hidden"
        console.debug("shareItem.userData = " + shareItem.userData);
        shareItem.start()
    }

    SailfishShare {
        id: shareItem
        source: root.source
        metadataStripped: true
        serviceId: root.methodId
    }

    DialogHeader {
        id: dialogHeader
        acceptText: qsTrId("Jockr Share")
    }

    SilicaFlickable {
        anchors {
            top: dialogHeader.bottom
            topMargin: Theme.paddingLarge
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        contentHeight: column.height

        Column {
            id: column

            width: parent.width
            spacing: Theme.paddingLarge

            TextField {
                id: mediaTitle
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: titleMedia
                label: "Title"
            }

            TextField {
                id: mediaDesc
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                placeholderText: qsTr("Description")
                text: ""
                label: qsTr("Description")
            }

            TextField {
                id: mediaTags
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                placeholderText: qsTr("Tags")
                text: ""
                label: qsTr("Tags")
            }

            ComboBox {
                id: mediaType
                width: parent.width
                label: qsTr("ontent Type: ")

                menu: ContextMenu {
                    MenuItem { text: "photo" }
                    MenuItem { text: "screenshot" }
                    MenuItem { text: "video" }
                }
            }

            ComboBox {
                id: mediaPrivacy
                width: parent.width
                label: qsTr("Privacy: ")

                menu: ContextMenu {
                    MenuItem { text: "private - only visible to me" }
                    MenuItem { text: "private - visible by friends" }
                    MenuItem { text: "private - visible by family" }
                    MenuItem { text: "public  - visible from all" }
                }
            }

            TextSwitch {
                id: mediaPublicReserch
                text: "no"
                description: qsTr("will be visible in public research")
                onCheckedChanged: {
                    text = checked ? qsTr("yes") : qsTr("no")
                }
            }

            ComboBox {
                id: mediaSafety
                width: parent.width
                label: "Safety level: "

                menu: ContextMenu {
                    MenuItem { text: "safe" }
                    MenuItem { text: "moderate" }
                    MenuItem { text: "limited" }
                }
            }
        }
    }
}
