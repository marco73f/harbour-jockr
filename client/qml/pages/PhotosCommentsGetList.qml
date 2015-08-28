import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.jockr 1.0
import "models"
import "delegates"

Page {
    id: page

    property string photoId

    property var modelInterface: FactoryModelInterface.getModelInterface(photosCommentsGetListModel.api)

    PhotosCommentsGetListModel {
        id: photosCommentsGetListModel

        Component.onCompleted: { modelInterface.queryApi("photo_id:" + photoId) }
    }

    Connections {
        target: modelInterface

        onXmlReady: {
            photosCommentsGetListModel.xml = xmlResponse
        }

        onFailed: {
            photosCommentsGetListModel.xml = ""
        }
    }

    SilicaListView {
        id: listView
        anchors.fill: parent
        clip: true

        header: PageHeader { title: qsTr("Comments") }

        delegate: commentDelegate
        model: photosCommentsGetListModel
        cacheBuffer: listView.height
        ScrollDecorator {}

        ViewPlaceholder {
            enabled: listView.count == 0
            text: photosCommentsGetListModel.strStatus
        }
    }

    Component {
        id: commentDelegate
        Item {
            width: parent.width - (Theme.paddingLarge * 2)
            height:  childrenRect.height + (Theme.paddingLarge * 2)
            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                id: buddyIcon
                source: "https://www.flickr.com/buddyicons/" + author + ".jpg"
                opacity: 0
                anchors {
                    left: parent.left
                    top:  parent.top
                    topMargin: Theme.paddingLarge
                }

                width: 48
                height: 48
                onStatusChanged: status == Image.Ready ? opacity = 1 : opacity = 0;
                Behavior on opacity { PropertyAnimation { duration: 300 } }
            }
            Text {
                id: authorName
                color: Theme.primaryColor
                text: authorname
                verticalAlignment: Text.AlignTop
                anchors {
                    left: buddyIcon.right
                    leftMargin: Theme.paddingLarge
                    top:  parent.top
                    topMargin: Theme.paddingLarge
                    right: parent.right
                }
            }
            Text {
                id: commentText
                color: Theme.highlightColor
                text: comment
                wrapMode: Text.Wrap
                textFormat: Text.RichText
                onLinkActivated: Qt.openUrlExternally(link)
                anchors {
                    left: buddyIcon.right
                    leftMargin: Theme.paddingLarge
                    top:  buddyIcon.bottom
                    right: parent.right
                }
            }
        }
    }
}

