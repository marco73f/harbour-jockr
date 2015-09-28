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

Dialog {
    id: page
    canAccept: Af.arr.length > 0

    property string title
    property string photoId
    property string photosetTitleText
    //property variant photos_id_selection: []


    Column {
        id: headerColumn
        width: parent.width
        spacing: 0

        DialogHeader {
            id: dialogHeader
            acceptText: page.title
        }

        TextField {
            id: photosetTitle
            x: Theme.paddingLarge
            focus: true
            width: parent.width
            //inputMethodHints: Qt.ImhDialableCharactersOnly
            text: page.photosetTitleText
            placeholderText: qsTr("Album name", "Name of the Album")
            label: qsTr("Album name", "Label for Album name in add photo or new album")
        }

        SilicaGridView {
            id: grid
            clip: true
            anchors {
                left: parent.left
                right: parent.right
            }
            height: page.height - (dialogHeader.height + photosetTitle.height + photosetDesc.height + (headerColumn.spacing * 2))
            cellWidth: width / 3
            cellHeight: cellWidth
            cacheBuffer: grid.height

            model: peopleGetPhotosModel

            delegate: JockrImage {
                width: grid.cellWidth
                height: grid.cellHeight
                selectionActivated: true
                source: "https://farm" + farm + ".staticflickr.com/" + server + "/" + id + "_" + secret + "_q.jpg"
                onClick: pageStack.push(Qt.resolvedUrl("FlickrSlideView.qml"), {currentIndex: index, model: grid.model} )
                onAddSelection: Af.arr.push(id)
                onRemoveSelection: {
                    var elementIndex = Af.arr.indexOf(id)
                    if (elementIndex >= 0) { Af.arr.splice(elementIndex, 1) }
                }
            }

            ScrollDecorator {}

            ViewPlaceholder {
                enabled: grid.count == 0
                text: peopleGetPhotosModel.strStatus
            }
        }
    }

    onDone: {
        if (result === DialogResult.Accepted) {
            photosetsRemoveModelPhoto()
        }
    }

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

    function photosetsRemoveModelPhoto(photo_ids) {
        photosetsRemovePhotosInterface.queryApi(photosetsRemovePhotosModel.params + photoId + photosetsRemovePhotosModel.photo_ids + Af.arr.join(","))
    }
}

