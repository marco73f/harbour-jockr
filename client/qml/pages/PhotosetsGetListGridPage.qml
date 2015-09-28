/*
Copyright (c) <2013>, Jolla Ltd.
Contact: Vesa-Matti Hartikainen <vesa-matti.hartikainen@jollamobile.com>

All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this
    list of conditions and the following disclaimer. Redistributions in binary
    form must reproduce the above copyright notice, this list of conditions and
    the following disclaimer in the documentation and/or other materials
    provided with the distribution. Neither the name of the Jolla Ltd. nor
    the names of its contributors may be used to endorse or promote products
    derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import Sailfish.Silica 1.0
import "models"
import "delegates"
import "../arrFunction.js" as Af
import harbour.jockr 1.0

Page {
    id: page
    property string title
    property string photosetTitle
    property string photosetDesc

    SilicaGridView {
        id: grid
        header: PageHeader { title: page.title }
        cellWidth: width / 2
        cellHeight: cellWidth + Theme.itemSizeExtraSmall
        cacheBuffer: grid.height
        anchors.fill: parent
        model: photosetsListModel
        property bool editMode: false

        PullDownMenu {
            busy: photosetsGetListModel.loading
//            MenuItem {
//                //enabled: photosetsGetListModel.page > 1
//                visible: photosetsGetListModel.page > 1
//                text: qsTr("Previous page")
//                onClicked: { photosetsGetListModelChangePage(--photosetsGetListModel.page); photosetsGetListModelTimer.start() }
//            }
            MenuItem {
                visible: !grid.editMode
                text: qsTr("Delete an Album")
                onClicked: { grid.editMode = true }
            }
            MenuItem {
                visible: !grid.editMode
                text: qsTr("Create an Album")
                onClicked: {
                    var dialogAddPage = pageStack.push(Qt.resolvedUrl("PhotosetsAddPage.qml"), {title: qsTr("Create"), createAlbum: true} )
                    dialogAddPage.accepted.connect(function() {
                        page.photosetTitle = dialogAddPage.photosetTitleText
                        page.photosetDesc = dialogAddPage.photosetDescText
                        photosetsCreateModelPhoto()
                    })
                }
            }
            MenuItem {
                visible: grid.editMode
                text: qsTr("Delete")
                onClicked: { Af.arr.length > 0; deleteRemorsePopup.execute(qsTr("Deleting album"), function() { page.photosetsDeleteModelPhoto() }, 5000) }
            }
            MenuItem {
                visible: grid.editMode
                text: qsTr("Undo")
                onClicked: { grid.editMode = false; Af.clearArr() }
            }
            MenuItem {
                visible: !grid.editMode
                text: qsTr("Update")
                onClicked: { photosetsGetListModelUpdate(); photosetsGetListModelTimer.start() }
            }
        }

//        PushUpMenu {
//            busy: photosetsGetListModel.loading
//            MenuItem {
//                enabled: photosetsGetListModel.pages > photosetsGetListModel.page
//                text: qsTr("Next page")
//                onClicked: {
//                        photosetsGetListModelChangePage(++photosetsGetListModel.page)
//                        photosetsGetListModel.xml = ""
//                        photosetsGetListModelTimer.start()
//                  }
//            }
//        }

        delegate: JockrPhotoset {
            width: grid.cellWidth
            height: grid.cellHeight
            source: urlFirstPhoto
            photosetId: id
            albumTitle: title
            editMode: grid.editMode
            onClick: pageStack.push(Qt.resolvedUrl("PhotosetsGetPhotosGridPage.qml"), { album_Title: title, photoset_Id: id, photoset_xml: xml } )
            onAddSelection: { Af.arr.push(photo_id) }
            onRemoveSelection: { var elementIndex = Af.arr.indexOf(photo_id); if (elementIndex >= 0) { Af.arr.splice(elementIndex, 1) } }
        }

        ScrollDecorator {}

        ViewPlaceholder {
            enabled: grid.count == 0
            text: photosetsGetListModel.strStatus
        }
    }

    PhotosetsDeleteModel {
        id: photosetsDeleteModel

        onStatusChanged: {
            if (status === XmlListModel.Ready) { strStatus = count + " Items loaded" }
            if (status === XmlListModel.Loading) { strStatus = "Loading" }
            if (status === XmlListModel.Error) { loading = false; strStatus = "Error:\n" + errorString }
            if (status === XmlListModel.Null) { strStatus = "Loading" }
        }
    }

    property var photosetsDeleteInterface: FactoryModelInterface.getModelInterface(photosetsDeleteModel.api)

    Connections {
        target: photosetsDeleteInterface

        onXmlReady: {
            photosetsDeleteModel.xml = xmlResponse
            photosetsGetListModelUpdate()
            photosetsGetListModelTimer.start()
        }

        onFailed: {
            photosetsDeleteModel.xml = ""
        }
    }

    function photosetsDeleteModelPhoto() {
        grid.editMode = false
        photosetsDeleteInterface.queryApi(photosetsDeleteModel.params + Af.arr.join(","))
        Af.clearArr()
        photosetsGetListModelTimer.start()
    }

    RemorsePopup {
        id: deleteRemorsePopup
    }

// add ########


    PhotosetsCreateModel {
        id: photosetsCreateModel

        onStatusChanged: {
            if (status === XmlListModel.Ready) {
                strStatus = "ready"
                console.log(strStatus)
                Af.arr.shift()
                photosetsAddPhotoModelPhoto(photosetsCreateModel.get(0).pid)
            }
            if (status === XmlListModel.Loading) { strStatus = "Loading"; console.log(strStatus) }
            if (status === XmlListModel.Error) { loading = false; strStatus = "Error:\n" + errorString; console.log(strStatus) }
            if (status === XmlListModel.Null) { strStatus = "Loading"; console.log(strStatus) }
        }
    }

    property var photosetsAddNewInterface: FactoryModelInterface.getModelInterface(photosetsCreateModel.api)

    Connections {
        target: photosetsAddNewInterface

        onXmlReady: {
            photosetsCreateModel.xml = xmlResponse
            console.log("xml = " + xmlResponse)
            //console.log("get(0).pid = " + photosetsCreateModel.get(0).pid); photosetsAddPhotoModelPhoto(photosetsCreateModel.get(0).pid)
            //photosetsGetListModelUpdate()
            //photosetsGetListModelTimer.start()
        }

        onFailed: {
            photosetsCreateModel.xml = ""
            console.log("failed")
        }
    }

    function photosetsCreateModelPhoto() {
        console.log(photosetsCreateModel.api)
        console.log(photosetsCreateModel.title + page.photosetTitle + photosetsCreateModel.description + page.photosetDesc + photosetsCreateModel.primary_photo_id + Af.arr[0])
        photosetsAddNewInterface.queryApi(photosetsCreateModel.title + page.photosetTitle + photosetsCreateModel.description + page.photosetDesc + photosetsCreateModel.primary_photo_id + Af.arr[0])
        console.log("album created")
    }


    PhotosetsAddPhotoModel {
        id: photosetsAddPhotoModel

        onStatusChanged: {
            if (status === XmlListModel.Ready) { strStatus = count + " Items loaded" }
            if (status === XmlListModel.Loading) { strStatus = "Loading" }
            if (status === XmlListModel.Error) { loading = false; strStatus = "Error:\n" + errorString }
            if (status === XmlListModel.Null) { strStatus = "Loading" }
        }
    }

    property var photosetsAddPhotoInterface: FactoryModelInterface.getModelInterface(photosetsAddPhotoModel.api)

    Connections {
        target: photosetsAddPhotoInterface

        onXmlReady: {
            photosetsAddPhotoModel.xml = xmlResponse
        }

        onFailed: {
            photosetsAddPhotoModel.xml = ""
        }
    }

    function photosetsAddPhotoModelPhoto(photosetId) {
        console.log("photosetsAddPhotoModelPhoto photosetId = " + photosetId + " Af.arr.length = " + Af.arr.length)
        for (var i = 0; Af.arr.length > i; i++) {
            console.log("#### " + photosetsAddPhotoModel.params + photosetId + photosetsAddPhotoModel.photo_id + Af.arr[i] + " ###")
            photosetsAddPhotoInterface.queryApi(photosetsAddPhotoModel.params + photosetId + photosetsAddPhotoModel.photo_id + Af.arr[i])
        }
        Af.clearArr()
        photosetsGetListModelUpdate()
        photosetsGetListModelTimer.start()
    }
}

