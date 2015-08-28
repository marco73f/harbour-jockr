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
import harbour.jockr 1.0

Page {
    id: page
    property string title

    SilicaListView {
        id: contactList
        anchors.fill: parent
        clip: true

        header: PageHeader { title: page.title }

        PullDownMenu {
            MenuItem {
                text: qsTr("Update")
                onClicked: {
                    contactsGetListModelUpdate()
                }
            }
        }

        delegate: BackgroundItem {
            width: ListView.view.width
            height: Theme.itemSizeMedium
            onClicked: pageStack.push(Qt.resolvedUrl("ContactsGetPhotosGridPage.qml"), { nsId: nsid, title: username })
            JockrBuddyIcon {
                id: buddyIcon
                iconFarm: iconfarm
                iconServer: iconserver
                nsId: nsid
                userName: username
                realName: realname
                clr: highlighted ? Theme.highlightColor : Theme.primaryColor
            }
        }
        model: contactsGetListModel
        cacheBuffer: contactList.height
        ScrollDecorator {}

        ViewPlaceholder {
            enabled: contactList.count == 0
            text: contactsGetListModel.strStatus
        }
    }
}
