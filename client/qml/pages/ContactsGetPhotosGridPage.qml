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
import Jockr 1.0
import "models"
import "delegates"


Page {
    id: page
    anchors.fill: parent
    property string title
    property string nsId
    property alias model: grid.model

    property var modelInterface: FactoryModelInterface.getModelInterface(contactsGetPhotosModel.api + "&user_id:" + nsId + ":")

    Connections {
        target: modelInterface

        onXmlReady: {
            contactsGetPhotosModel.xml = xmlResponse
        }

        onFailed: {
            contactsGetPhotosModel.xml = ""
        }
    }

    PeopleGetPhotosModel {
        id: contactsGetPhotosModel

        Component.onCompleted: {
            modelInterface.queryApi(params)
        }

        onStatusChanged: {
            if (status === XmlListModel.Ready) { strStatus = count + " Items loaded" }
            if (status === XmlListModel.Loading) { strStatus = "Loading" }
            if (status === XmlListModel.Error) { strStatus = "Error:\n" + errorString }
            if (status === XmlListModel.Null) { strStatus = "Loading" }
        }
    }

    SilicaGridView {
        id: grid
        header: PageHeader { title: page.title }
        cellWidth: width / 3
        cellHeight: cellWidth
        cacheBuffer: grid.height
        anchors.fill: parent
        model: contactsGetPhotosModel

        PullDownMenu {
            MenuItem {
                text: qsTr("Update")
                onClicked: {
                    modelInterface.queryApi(contactsGetPhotosModel.params)
                }
            }
        }

        delegate: JockrImage {
            width: grid.cellWidth
            height: grid.cellHeight
            source: "https://farm" + farm + ".staticflickr.com/" + server + "/" + id + "_" + secret + "_q.jpg"
            onClick: pageStack.push(Qt.resolvedUrl("FlickrSlideView.qml"), {currentIndex: index, model: grid.model} )
        }

        ScrollDecorator {}

        ViewPlaceholder {
            enabled: grid.count == 0
            text: contactsGetPhotosModel.strStatus
        }
    }
}

