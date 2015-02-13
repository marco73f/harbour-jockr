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
    property int currentTab: 0

    Component.onCompleted: { OAuth.doOAuth() }

        PageHeader {
            id: pageHeader

            Label {
                anchors {
                    top: parent.top
                    topMargin: Theme.largePadding
                    horizontalCenter: parent.horizontalCenter
                }

                text: listPages.get(currentTab).name
            }

            Row {
                anchors {
                    bottom: parent.bottom
                    bottomMargin: Theme.largePadding
                    horizontalCenter: parent.horizontalCenter
                }

                width: listPages.count * 20

                Repeater {
                    id: listTabs
                    model: listPages.count
                    delegate: GlassItem {
                        id: msgStatusView
                        width: index == root.currentTab ? 40 : 20
                        height: width
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }

    Item {
        id: container
        anchors {
            top: pageHeader.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
    }

    property Item containerObject
    property bool autorizationPageIsOpen: false

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
                setContainerObject(jockrPages.createObject(container))
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
        id: jockrPages

        SlideshowView {
            id: view
            currentIndex: 0

            anchors.fill: parent
            itemWidth: width
            itemHeight: height

            onCurrentIndexChanged: listPages.activePage(currentIndex)

            model: listPages
            delegate: Component {
                id: delegateComponent
                Loader {
                    id: loaderPage
                    width: view.itemWidth
                    height: view.itemHeight
                    asynchronous: false
                    source: load ? page : ""
                }
            }
        }
    }

    ListModel{
        id: listPages

        function activePage(idx) {
            root.currentTab = idx
            set(idx, {load: true})
        }

        ListElement { name: "Recent Photos"; page: "PhotoListView.qml"; load: true }
        ListElement { name: "Recent Contacts Photos"; page: "PhotosGetContactsPhotosPage.qml"; load: false }
        ListElement { name: "User ????"; page: "UserPage.qml"; load: false }
        ListElement { name: "Activity User Photos"; page: "ActivityUserPhotos.qml"; load: false }
        ListElement { name: "Contacts"; page: "ContactsGetList.qml"; load: false }
        ListElement { name: "Favorites"; page: "FavoritesGetList.qml"; load: false }
    }
}
