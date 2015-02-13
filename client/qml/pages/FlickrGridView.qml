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
import Sailfish.Silica 1.0
import "models"
import "delegates"
import Jockr 1.0

Page {
    id: page
    anchors.fill: parent

    property var modelInterface: FactoryModelInterface.getModelInterface(photosGetContactsPhotosModel.api)

    PhotosGetContactsPhotosModel {
        id: photosGetContactsPhotosModel

        Component.onCompleted: { modelInterface.queryApi(params) }
    }

    Connections {
        target: modelInterface

        onXmlReady: {
            photosGetContactsPhotosModel.xml = xmlResponse
        }

        onFailed: {
            photosGetContactsPhotosModel.xml = ""
        }
    }

    SilicaGridView {
        id: grid
        header: PageHeader { title: qsTr("Images") }
        cellWidth: width / 3
        cellHeight: cellWidth
        cacheBuffer: grid.height
        anchors.fill: parent
        model: photosGetContactsPhotosModel
        cache: height * 4

        delegate: JockrImage {
            width: grid.cellWidth
            height: grid.cellHeight
            source: "https://farm" + farm + ".staticflickr.com/" + server + "/" + id + "_" + secret + "_q.jpg"
            onClick: pageStack.push(Qt.resolvedUrl("FlickrSlideView.qml"), {currentIndex: index, model: grid.model} )
        }

        ScrollDecorator {}
    }
}

