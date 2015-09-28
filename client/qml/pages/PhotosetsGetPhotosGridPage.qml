import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0
import "models"
import "delegates"
import "../arrFunction.js" as Af
import harbour.jockr 1.0

Page {
    id: page
    property string photoset_Id
    property string album_Title
    property string photoset_xml
    property int counterAddPhoto: 0

    property bool justOpened: false

    property var modelInterface: FactoryModelInterface.getModelInterface(photosetListModel.api + "&photoset_id:" + photoset_Id + ":")

    onStatusChanged: {
        if (status === PageStatus.Active) {
            if (!justOpened) { photosetListModel.xml = photoset_xml }
            justOpened = true
        }
    }

    Connections {
        target: modelInterface

        onXmlReady: {
            photosetListModel.xml = xmlResponse
        }

        onFailed: {
            photosetListModel.xml = ""
        }
    }

    PhotosetsGetPhotosModel {
        id: photosetListModel
        property int lpage: 1

        onStatusChanged: {
            if (status === XmlListModel.Ready) { strStatus = count + qsTr(" Items loaded") }
            if (status === XmlListModel.Loading) { strStatus = qsTr("Loading") }
            if (status === XmlListModel.Error) { strStatus = qsTr("Error:") + "\n" + errorString }
            if (status === XmlListModel.Null) { strStatus = qsTr("Loading") }
        }
    }

    function photosetListModelChangePage(pageNumber) {
        modelInterface.queryApi("page:" + pageNumber)
    }

    Timer {
        id: photosetListModelTimer
        interval: 2000
        running: false
        repeat: false
        triggeredOnStart: true
        onTriggered: photosetListModel.loading = !photosetListModel.loading
    }

    SilicaGridView {
        id: grid
        header: PageHeader { title: page.album_Title }
        cellWidth: width / 3
        cellHeight: cellWidth
        cacheBuffer: grid.height
        anchors.fill: parent
        model: photosetListModel
        property bool editMode: false

        PullDownMenu {
            busy: photosetsGetPhotosModel.loading
            MenuItem {
                visible: !grid.editMode
                text: qsTr("Remove images")
                onClicked: { grid.editMode = true }
            }
            MenuItem {
                visible: !grid.editMode
                text: qsTr("Add image")
                onClicked: {
                    var dialogAddPage = pageStack.push(Qt.resolvedUrl("PhotosetsAddPage.qml"), {title: qsTr("Add"), createAlbum: false} )
                    dialogAddPage.accepted.connect(function() {
                        photosetAddPhotoModelPhoto()
                    })
                }
            }
            MenuItem {
                visible: grid.editMode
                text: qsTr("Remove from album")
                onClicked: { Af.arr.length > 0; deleteRemorsePopup.execute(qsTr("Removing photos form album"), function() { page.photosDeleteModelPhoto() }, 5000) }
            }
            MenuItem {
                visible: grid.editMode
                text: qsTr("Undo")
                onClicked: { grid.editMode = false; Af.clearArr() }
            }
            MenuItem {
                visible: photosetListModel.lpage > 1
                text: qsTr("Previous page")
                onClicked: { photosetListModelChangePage(--photosetsGetPhotosModel.lpage); photosetListModelTimer.start() }
            }
            MenuItem {
                text: qsTr("Update")
                onClicked: { photosetListModelChangePage(photosetsGetPhotosModel.lpage); photosetListModelTimer.start() }
            }
        }

        PushUpMenu {
            busy: photosetsGetPhotosModel.loading
            MenuItem {
                enabled: photosetListModel.pages > photosetListModel.lpage && photosetListModel.count >= GValue.per_page
                text: qsTr("Next page")
                onClicked: {
                    photosetListModelChangePage(++photosetsGetPhotosModel.page)
                    photosetListModel.xml = ""
                    photosetListModelTimer.start()
                }
            }
        }

        delegate: JockrImage {
            width: grid.cellWidth
            height: grid.cellHeight
            selectionActivated: grid.editMode
            source: "https://farm" + farm + ".staticflickr.com/" + server + "/" + id + "_" + secret + "_q.jpg"
            onClick: pageStack.push(Qt.resolvedUrl("FlickrSlideView.qml"), {currentIndex: index, model: grid.model} )
            onAddSelection: { Af.arr.push(id) }
            onRemoveSelection: { var elementIndex = Af.arr.indexOf(id); if (elementIndex >= 0) { Af.arr.splice(elementIndex, 1) } }
        }

        ScrollDecorator {}
    }

    PhotosetsAddPhotoModel {
        id: photosetAddPhotoModel

        onStatusChanged: {
            if (status === XmlListModel.Ready) { strStatus = count + " Items loaded" }
            if (status === XmlListModel.Loading) { strStatus = "Loading" }
            if (status === XmlListModel.Error) { loading = false; strStatus = "Error:\n" + errorString }
            if (status === XmlListModel.Null) { strStatus = "Loading" }
        }
    }

    property var photosetAddPhotoInterface: FactoryModelInterface.getModelInterface(photosetAddPhotoModel.api)

    Connections {
        target: photosetAddPhotoInterface

        onXmlReady: {
            photosetAddPhotoModel.xml = xmlResponse
            counterAddPhoto++
            if (counterAddPhoto === Af.arr.length) {
                photosetListModelChangePage(photosetsGetPhotosModel.lpage)
                photosetListModelTimer.start()
                Af.clearArr()
            }
        }

        onFailed: {
            photosetAddPhotoModel.xml = ""
        }
    }

    function photosetAddPhotoModelPhoto() {
        console.log("photosetAddPhotoModelPhoto photosetId = " + page.photoset_Id + " Af.arr.length = " + Af.arr.length)
        for (var i = 0; Af.arr.length > i; i++) {
            console.log("#### " + photosetAddPhotoModel.params + page.photoset_Id + photosetAddPhotoModel.photo_id + Af.arr[i] + " ###")
            photosetAddPhotoInterface.queryApi(photosetAddPhotoModel.params + page.photoset_Id + photosetAddPhotoModel.photo_id + Af.arr[i])
        }
    }

    // Delete function

    PhotosetsRemovePhotosModel {
        id: photosetsRemovePhotosModel

        onStatusChanged: {
            if (status === XmlListModel.Ready) { strStatus = count + " Items loaded" }
            if (status === XmlListModel.Loading) { strStatus = "Loading" }
            if (status === XmlListModel.Error) { loading = false; strStatus = "Error:\n" + errorString }
            if (status === XmlListModel.Null) { strStatus = "Loading" }
        }
    }

    property var photosetsRemovePhotosInterface: FactoryModelInterface.getModelInterface(photosetsRemovePhotosModel.api)

    Connections {
        target: photosetsRemovePhotosInterface

        onXmlReady: {
            photosetsRemovePhotosModel.xml = xmlResponse
            photosetListModelChangePage(photosetsGetPhotosModel.lpage)
            photosetListModelTimer.start()
        }

        onFailed: {
            photosetsRemovePhotosModel.xml = ""
        }
    }

    function photosDeleteModelPhoto() {
        grid.editMode = false
        photosetsRemovePhotosInterface.queryApi(photosetsRemovePhotosModel.params + page.photoset_Id + photosetsRemovePhotosModel.photo_ids + Af.arr.join(","))
        Af.clearArr()
        photosetsGetListModelUpdate()
    }

    RemorsePopup {
        id: deleteRemorsePopup
    }
}

