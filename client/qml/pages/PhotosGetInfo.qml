import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0
import "models"
import "delegates"
import Jockr 1.0

Page {
    id: page
    anchors.fill: parent

    property string photoId
    property string photoSecret

    property var modelInterface: FactoryModelInterface.getModelInterface(photosGetInfoModel.api)

    function getDateFromEpoc(epoc) {
        var dateVal ="/Date(" + epoc + ")/"
        var date = new Date(parseFloat(dateVal.substr(6))*1000);
        return date.toGMTString()
    }

    PhotosGetInfoModel {
        id: photosGetInfoModel

        Component.onCompleted: { modelInterface.queryApi("photo_id:" + photoId) }

        onStatusChanged: {
            if (status === XmlListModel.Ready) {
                strStatus = count + " Items loaded"
                dateuploadedPhoto.text += getDateFromEpoc(get(0).dateuploaded)
                isfavoritePhoto.text += get(0).isfavorite === 0 ? "No" : "Yes"
                licensePhoto.text += get(0).license
                switch (get(0).safety_level) {
                case 0: safety_levelPhoto.text += "safe"
                    break;
                case 1: safety_levelPhoto.text += "moderate"
                    break;
                case 2: safety_levelPhoto.text += "limited"
                    break;
                }
                rotationPhoto.text += get(0).rotation
                originalformatPhoto.text += get(0).originalformat
                viewsPhoto.text += get(0).views
                mediaPhoto.text += get(0).media

                ownerUsernamePhoto.text += get(0).ownerUsername
                ownerRealnamePhoto.text += get(0).ownerRealname
                ownerLocationPhoto.text += get(0).ownerLocation

                titlePhoto.text = get(0).title
                descriptionPhoto.text = get(0).description

                if (get(0).ispublic === 0) {
                    ispublicPhoto.text += "No"
                    isfriendPhoto.text += get(0).isfriend === 0 ? "No" : "Yes"
                    isfamilyPhoto.text += get(0).isfamily === 0 ? "No" : "Yes"
                } else {
                    ispublicPhoto.text += "Yes"
                    isfriendPhoto.text += "Yes"
                    isfamilyPhoto.text += "Yes"
                }

                datePostedPhoto.text += getDateFromEpoc(get(0).datePosted)
                dateTakenPhoto.text += getDateFromEpoc(get(0).dateTaken)
                lastupdatePhoto.text += getDateFromEpoc(get(0).lastupdate)

                permcommentPhoto.text += get(0).permcomment
                permaddmetaPhoto.text += get(0).permaddmeta
                cancommentPhoto.text += get(0).cancomment
                canaddmetaPhoto.text += get(0).canaddmeta
                publicCancommentPhoto.text += get(0).publicCancomment
                publicCanaddmetaPhoto.text += get(0).publicCanaddmeta
                candownloadPhoto.text += get(0).candownload
                canblogPhoto.text += get(0).canblog
                cansharePhoto.text += get(0).canshare

                commentsPhoto.text += get(0).comments
                notesPhoto.text += get(0).notes
                haspeoplePhoto.text += get(0).haspeople
            }
            if (status === XmlListModel.Loading) { strStatus = "Loading" }
            if (status === XmlListModel.Error) { strStatus = "Error:\n" + errorString }
            if (status === XmlListModel.Null) { strStatus = "Loading" }
        }
    }

    Connections {
        target: modelInterface

        onXmlReady: {
            photosGetInfoModel.xml = xmlResponse
        }

        onFailed: {
            photosGetInfoModel.xml = ""
        }
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: parent.width
            height: children.height
            spacing: 20
            PageHeader { title: qsTr("Page Info") }

            /* Photo id
            Label {
                id: idPhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: "id: "
            }
            Label {
                id: secretPhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: "secret: "
            }
            Label {
                id: serverPhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: "server: "
            }
            Label {
                id: farmPhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: "farm: "
            }
            */

            /* info */
            Label {
                id: titlePhotoLabel
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("title:")
            }
            Label {
                id: titlePhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
            }
            Label {
                id: descriptionPhotoLabel
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("description:")
            }
            TextArea {
                id: descriptionPhoto
                width: parent.width
                height: Theme.itemSizeLarge * 2
                focus: false
                readOnly: true
            }
            Label {
                id: mediaPhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("media: ")
            }

            /* Privacys */
            Label {
                width: parent.width
                color: Theme.highlightColor
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("Privacy")
            }
            Separator {
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
            }
            Label {
                id: ispublicPhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("public: ")
            }
            Label {
                id: isfriendPhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("visible by friend: ")
            }
            Label {
                id: isfamilyPhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("visible by family: ")
            }

            /* owner */
            Label {
                width: parent.width
                color: Theme.highlightColor
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("Owener Info")
            }
            Separator {
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
            }
            /*
            Label {
                id: ownerNsidPhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: "ownerNsid: "
            }
            */
            Label {
                id: ownerUsernamePhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("ownerUsername: ")
            }
            Label {
                id: ownerRealnamePhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("ownerRealname: ")
            }
            Label {
                id: ownerLocationPhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("ownerLocation: ")
            }
            /*
            Label {
                id: ownerIconserverPhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: "ownerIconserver: "
            }
            Label {
                id: ownerIconfarmPhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: "ownerIconfarm: "
            }
            Label {
                id: ownerPath_aliasPhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: "ownerPath_alias: "
            }
            */

            Label {
                id: isfavoritePhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("favorite: ")
            }
            Label {
                id: licensePhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("license: ")
            }
            Label {
                id: safety_levelPhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("safety level: ")
            }
            Label {
                id: rotationPhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("rotation: ")
            }
            /*
            Label {
                id: originalsecretPhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: "originalsecret: "
            }
            */
            Label {
                id: originalformatPhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("originalformat: ")
            }
            Label {
                id: viewsPhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("views: ")
            }

            /* Date */
            Label {
                width: parent.width
                color: Theme.highlightColor
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("Date Info")
            }
            Separator {
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
            }
            Label {
                id: dateuploadedPhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("Upload: ")
            }
            Label {
                id: datePostedPhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("Posted: ")
            }
            Label {
                id: dateTakenPhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("Taken: ")
            }
            /*
            Label {
                id: dateTakengranularityPhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: "dateTakengranularity: "
            }
            */
            Label {
                id: lastupdatePhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("Update: ")
            }

            /* comments and notes */
            Label {
                width: parent.width
                color: Theme.highlightColor
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("Comments and notes")
            }
            Separator {
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
            }
            Label {
                id: commentsPhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: "comments: "
            }
            Label {
                id: notesPhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("notes: ")
            }
            Label {
                id: haspeoplePhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("haspeople: ")
            }

            /* permition */
            Label {
                width: parent.width
                color: Theme.highlightColor
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("Permition")
            }
            Separator {
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
            }
            Label {
                id: permcommentPhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("permcomment: ")
            }
            Label {
                id: permaddmetaPhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("permaddmeta: ")
            }
            Label {
                id: cancommentPhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("cancomment: ")
            }
            Label {
                id: canaddmetaPhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("canaddmeta: ")
            }
            Label {
                id: publicCancommentPhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("publicCancomment: ")
            }
            Label {
                id: publicCanaddmetaPhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("publicCanaddmeta: ")
            }
            Label {
                id: candownloadPhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("candownload: ")
            }
            Label {
                id: canblogPhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("canblog: ")
            }
            Label {
                id: cansharePhoto
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("canshare: ")
            }

        }
    }
}
