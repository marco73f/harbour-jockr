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

SilicaListView {
    id: userPage
    anchors.fill: parent
    clip: true

    PullDownMenu {
        MenuItem {
            text: qsTr("Search friends")
            onClicked: console.debug("Search friends clicked")
        MenuItem {
            text: qsTr("Change photoes")
            onClicked: console.debug("Change photoes clicked")
        }
        MenuItem {
            text: qsTr("Change Avatar")
            onClicked: console.debug("Change Avatar clicked")
        }
        MenuItem {
            text: qsTr("Settings")
            onClicked: console.debug("Settings clicked")
        }
    }

    ListModel {
        id: listModel
        ListElement { name: "All"; page: "PeopleGetPhotosGridPage.qml" }
        ListElement { name: "Public"; page: "PeopleGetPublicPhotosPage.qml" }
        ListElement { name: "Photosets"; page: "PhotosetsGetListGridPage.qml" }
        ListElement { name: "Groups"; page: "???.qml" }
    }

    delegate: BackgroundItem {
        width: ListView.view.width
        height: Theme.itemSizeMedium
        onClicked: {
            console.debug("page = " + page)
            pageStack.push(Qt.resolvedUrl(page))
        }
        Label {
            anchors {
                left: parent.left
                leftMargin: Theme.paddingLarge
                verticalCenter: parent.verticalCenter
            }
            text: name
        }
    }
    model: listModel
    cacheBuffer: userPage.height
    ScrollDecorator {}
    }
}
