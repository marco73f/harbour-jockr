import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0
import "models"
import "delegates"
import harbour.jockr 1.0

Page {
    id: page

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
                dateuploadedPhoto.value = getDateFromEpoc(get(0).dateuploaded)
                isfavoritePhoto.value = get(0).isfavorite === 0 ? "No" : "Yes"
                licensePhoto.value = get(0).license
                switch (get(0).safety_level) {
                case 0: safety_levelPhoto.value = "safe"
                    break;
                case 1: safety_levelPhoto.value = "moderate"
                    break;
                case 2: safety_levelPhoto.value = "limited"
                    break;
                }
                rotationPhoto.value = get(0).rotation
                originalformatPhoto.value = get(0).originalformat
                viewsPhoto.value = get(0).views
                mediaPhoto.value = get(0).media

                ownerUsernamePhoto.value = get(0).ownerUsername
                ownerRealnamePhoto.value = get(0).ownerRealname
                ownerLocationPhoto.value = get(0).ownerLocation

                titlePhoto.value = get(0).title
                descriptionPhoto.value = get(0).description

                if (get(0).ispublic === 0) {
                    ispublicPhoto.value = "No"
                    isfriendPhoto.value = get(0).isfriend === 0 ? "No" : "Yes"
                    isfamilyPhoto.value = get(0).isfamily === 0 ? "No" : "Yes"
                } else {
                    ispublicPhoto.value = "Yes"
                    isfriendPhoto.value = "Yes"
                    isfamilyPhoto.value = "Yes"
                }

                datePostedPhoto.value = getDateFromEpoc(get(0).datePosted)
                dateTakenPhoto.value = getDateFromEpoc(get(0).dateTaken)
                lastupdatePhoto.value = getDateFromEpoc(get(0).lastupdate)

                permcommentPhoto.value = get(0).permcomment
                permaddmetaPhoto.value = get(0).permaddmeta
                cancommentPhoto.value = get(0).cancomment
                canaddmetaPhoto.value += get(0).canaddmeta
                publicCancommentPhoto.value = get(0).publicCancomment
                publicCanaddmetaPhoto.value = get(0).publicCanaddmeta
                candownloadPhoto.value = get(0).candownload
                canblogPhoto.value = get(0).canblog
                cansharePhoto.value = get(0).canshare

                commentsPhoto.value = get(0).comments
                notesPhoto.value = get(0).notes
                haspeoplePhoto.value = get(0).haspeople
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
            property int widthLabel: width - Theme.paddingLarge
            width: parent.width
            height: children.height
            spacing: 20
            PageHeader { title: qsTr("Page Info") }

            /* Photo id
            Label {
                id: idPhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: "id: "
            }
            Label {
                id: secretPhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: "secret: "
            }
            Label {
                id: serverPhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: "server: "
            }
            Label {
                id: farmPhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: "farm: "
            }
            */

            /* info */
            DetailItem {
                id: titlePhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                label: qsTr("title")
            }
            DetailItem {
                id: descriptionPhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                label: qsTr("description")
            }
            DetailItem {
                id: mediaPhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                label: qsTr("media")
            }

            /* Privacys */
            Label {
                width: column.widthLabel
                color: Theme.highlightColor
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("Privacy")
            }
            Separator {
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
            }
            DetailItem {
                id: ispublicPhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                label: qsTr("public")
            }
            DetailItem {
                id: isfriendPhoto
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                label: qsTr("visible by friend")
            }
            DetailItem {
                id: isfamilyPhoto
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                label: qsTr("visible by family")
            }

            /* owner */
            Label {
                width: column.widthLabel
                color: Theme.highlightColor
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("Owener Info")
            }
            Separator {
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
            }
            /*
            Label {
                id: ownerNsidPhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: "ownerNsid: "
            }
            */
            DetailItem {
                id: ownerUsernamePhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                label: qsTr("ownerUsername")
            }
            DetailItem {
                id: ownerRealnamePhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                label: qsTr("ownerRealname")
            }
            DetailItem {
                id: ownerLocationPhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                label: qsTr("ownerLocation")
            }
            /*
            Label {
                id: ownerIconserverPhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: "ownerIconserver: "
            }
            Label {
                id: ownerIconfarmPhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: "ownerIconfarm: "
            }
            Label {
                id: ownerPath_aliasPhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: "ownerPath_alias: "
            }
            */

            DetailItem {
                id: isfavoritePhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                label: qsTr("favorite")
            }
            DetailItem {
                id: licensePhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                label: qsTr("license")
            }
            DetailItem {
                id: safety_levelPhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                label: qsTr("safety level")
            }
            DetailItem {
                id: rotationPhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                label: qsTr("rotation")
            }
            /*
            Label {
                id: originalsecretPhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: "originalsecret: "
            }
            */
            DetailItem {
                id: originalformatPhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                label: qsTr("originalformat")
            }
            DetailItem {
                id: viewsPhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                label: qsTr("views")
            }

            /* Date */
            Label {
                width: column.widthLabel
                color: Theme.highlightColor
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("Date Info")
            }
            Separator {
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
            }
            DetailItem {
                id: dateuploadedPhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                label: qsTr("Upload")
            }
            DetailItem {
                id: datePostedPhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                label: qsTr("Posted")
            }
            DetailItem {
                id: dateTakenPhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                label: qsTr("Taken")
            }
            /*
            Label {
                id: dateTakengranularityPhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: "dateTakengranularity: "
            }
            */
            DetailItem {
                id: lastupdatePhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                label: qsTr("Update")
            }

            /* comments and notes */
            Label {
                width: column.widthLabel
                color: Theme.highlightColor
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("Comments and notes")
            }
            Separator {
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
            }
            DetailItem {
                id: commentsPhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                label: qsTr("Comments")
            }
            DetailItem {
                id: notesPhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                label: qsTr("notes")
            }
            DetailItem {
                id: haspeoplePhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                label: qsTr("haspeople")
            }

            /* permition */
            Label {
                width: column.widthLabel
                color: Theme.highlightColor
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: qsTr("Permition")
            }
            Separator {
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
            }
            DetailItem {
                id: permcommentPhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                label: qsTr("permcomment")
            }
            DetailItem {
                id: permaddmetaPhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                label: qsTr("permaddmeta")
            }
            DetailItem {
                id: cancommentPhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                label: qsTr("cancomment")
            }
            DetailItem {
                id: canaddmetaPhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                label: qsTr("canaddmeta")
            }
            DetailItem {
                id: publicCancommentPhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                label: qsTr("publicCancomment")
            }
            DetailItem {
                id: publicCanaddmetaPhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                label: qsTr("publicCanaddmeta")
            }
            DetailItem {
                id: candownloadPhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                label: qsTr("candownload")
            }
            DetailItem {
                id: canblogPhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                label: qsTr("canblog")
            }
            DetailItem {
                id: cansharePhoto
                width: column.widthLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                label: qsTr("canshare")
            }

        }
    }
}
