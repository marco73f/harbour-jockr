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

    property string title
    property string photoId
    property alias photosetTitle: phTitle.text
    property alias photosetDesc: phDesc.text
    property string photosetTitleText
    property string photosetDescText
    property bool createAlbum
    property variant photos_id_selection: []

    Component.onCompleted: {
        if (createAlbum) {
            grid.height = page.height - (dialogHeader.height + phTitle.height + phDesc.height + (headerColumn.spacing * 2))
        }
        else {
            grid.height = page.height - dialogHeader.height
        }
    }

    Column {
        id: headerColumn
        width: parent.width
        spacing: 0

        DialogHeader {
            id: dialogHeader
            acceptText: page.title
        }

        TextField {
            id: phTitle
            visible: createAlbum
            x: Theme.paddingLarge
            focus: createAlbum
            width: parent.width
            //inputMethodHints: Qt.ImhDialableCharactersOnly
            placeholderText: qsTr("Album name", "Name of the Album")
            label: qsTr("Album name", "Label for Album name in add photo or new album")
        }

        TextField {
            id: phDesc
            visible: createAlbum
            x: Theme.paddingLarge
            width: parent.width
            //inputMethodHints: Qt.ImhDialableCharactersOnly
            placeholderText: qsTr("Description", "Description of the Album")
            label: qsTr("Description", "Label for Description of the new album")
        }

        SilicaGridView {
            id: grid
            clip: true
            cellWidth: width / 3
            cellHeight: cellWidth
            cacheBuffer: grid.height

            anchors {
                left: parent.left
                right: parent.right
            }

            model: peopleGetPhotosModel

            delegate: JockrImage {
                width: grid.cellWidth
                height: grid.cellHeight
                selectionActivated: true
                source: "https://farm" + farm + ".staticflickr.com/" + server + "/" + id + "_" + secret + "_q.jpg"
                onClick: pageStack.push(Qt.resolvedUrl("FlickrSlideView.qml"), {currentIndex: index, model: grid.model} )
                onAddSelection: { console.log("id:" + id); Af.arr.push(id); console.log("Af.arr[0]" + Af.arr[0]); console.log("Af.arr.length" + Af.arr.length) }
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
            photosetTitleText = photosetTitle
            photosetDescText = photosetDesc
        }
    }
}

