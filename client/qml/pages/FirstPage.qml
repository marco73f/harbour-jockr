/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import Jockr 1.0


Page {
    id: root

    Component.onCompleted: {
        OAuth.doOAuth()
    }

    Item {
        id: container
        anchors.fill: parent
    }

    property Item containerObject;
    property bool autorizationPageIsOpen: false;

    function setContainerObject(obj) {
        if (containerObject != null) {
            containerObject.destroy();
        }
        containerObject = obj;
    }

    Connections {
        target: OAuth

        onUserLoggedInChanged: {
            if (autorizationPageIsOpen) {
                pageStack.pop();
                autorizationPageIsOpen = false;
            }

            if (OAuth.userLoggedIn) {
                setContainerObject(menuDynamicPage.createObject(container))
            }
            else {
                setContainerObject(errorDynamicPage.createObject(container));
            }
        }

        onOpenAuthorizeWebPage: {
            autorizationPageIsOpen = true;
            pageStack.push(Qt.resolvedUrl("AuthorizationPage.qml"), {webUrl: url})
        }
    }

    Component {
        id: errorDynamicPage
        Column {
            id: pageColumn
            anchors.centerIn: parent
            spacing: Theme.paddingMedium

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Error Page")
                font.bold: true
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: ConnMan.netConnected ? qsTr("Network: <b>connected</b>") : qsTr("Network: <b>not connected</b>")
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Reload")
            }
        }
    }

    Component {
        id: menuDynamicPage
        SilicaListView {
            id: listView

            PullDownMenu {
                MenuItem {
                    text: "Option 1"
                }
                MenuItem {
                    text: "Option 2"
                }
            }

            anchors.fill: parent

            header: PageHeader {
                title: "Flickr Pages"
            }

            delegate: BackgroundItem {
                id: delegate

                Label {
                    x: Theme.paddingLarge
                    text: name
                    anchors.verticalCenter: parent.verticalCenter
                    color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                }
                onClicked: pageStack.push(Qt.resolvedUrl(page))
            }

            VerticalScrollDecorator {}

            model: ListModel{
                id: listmodel

                ListElement {
                    name: "Photos Get Contacts Photos"
                    page: "FlickrGridView.qml"
                }

                ListElement {
                    name: "Photos Get Contacts Photos"
                    page: "DefaultView.qml"
                }

                ListElement {
                    name: "Recent Uploads"
                    page: "PhotosGetContactsPublicPhotos.qml"
                }
                ListElement {
                    name: "Recent activity"
                    page: "ActivityUserPhotos.qml"
                }
                ListElement {
                    name: "Photo list view"
                    page: "PhotoListView.qml"
                }
                ListElement {
                    name: "Contacts"
                    page: "ContactsGetList.qml"
                }
                ListElement {
                    name: "Favorites"
                    page: "FavoritesGetList.qml"
                }
                ListElement {
                    name: "Settings & About"
                    page: "settings"
                }
            }
        }
    }
}

