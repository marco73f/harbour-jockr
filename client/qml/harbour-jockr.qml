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
import QtQuick.XmlListModel 2.0
import harbour.jockr 1.0
import "pages/models"
import "functions.js" as Flib

ApplicationWindow
{
    id: window
    Component.onCompleted: {
            OAuth.doOAuth()
    }

    property bool autorizationPageIsOpen: false
    property string nsid: OAuth.nsid
    property string peopleGetPhotosGridPage: qsTr("All photos")
    property string peopleGetPublicPhotosPage: qsTr("Public photos")
    property string photosetsGetListGridPage: qsTr("Albums")
    property string favoritesGetListPage: qsTr("Favorites")
    property string groupsGetListGridPage: qsTr("Groups")
    property string photosGetContactsPhotosPage: qsTr("Recently uploaded")
    property string contactsGetListPage: qsTr("Contacts")
    property string photoListView: qsTr("Explores flickr")
    property string loadingMessage: qsTr("Loading")
    property string loadedMessage: qsTr("Loaded")

    Connections {
        target: OAuth

        onUserLoggedInChanged: {
            if (autorizationPageIsOpen) {
                pageStack.pop();
                autorizationPageIsOpen = false;
            }

            if (OAuth.userLoggedIn) {
                updateAllModel()
                pageStack.replace(Qt.resolvedUrl("pages/JockrMainView.qml"))
                nsid = OAuth.nsid
            }
        }

        onOpenSignOutWebPage: {
            autorizationPageIsOpen = true;
            pageStack.push(Qt.resolvedUrl("pages/SignOutPage.qml"), {webUrl: url})
        }

        onOpenAuthorizeWebPage: {
            autorizationPageIsOpen = true;
            pageStack.push(Qt.resolvedUrl("pages/AuthorizationPage.qml"), {webUrl: url})
        }
    }

    cover: Qt.resolvedUrl("cover/CoverPage.qml")

    ListModel {
        id: mainMenuModel
        ListElement { tab: ""; sourcePlasceHolderIcon: "image://theme/icon-cover-camera"; sourceBuddyIcon: ""; stateBuddyIcon: ""; page: "PeopleGetPhotosGridPage.qml"; num: 0 }
        ListElement { tab: ""; sourcePlasceHolderIcon: "image://theme/icon-camera-portrait"; sourceBuddyIcon: ""; stateBuddyIcon: ""; page: "PeopleGetPublicPhotosPage.qml"; num: 0 }
        ListElement { tab: ""; sourcePlasceHolderIcon: "image://theme/icon-camera-landscape"; sourceBuddyIcon: ""; stateBuddyIcon: ""; page: "PhotosetsGetListGridPage.qml"; num: 0 }
        ListElement { tab: ""; sourcePlasceHolderIcon: "image://theme/icon-cover-favorite"; sourceBuddyIcon: ""; stateBuddyIcon: ""; page: "FavoritesGetList.qml"; num: 0 }
        ListElement { tab: ""; sourcePlasceHolderIcon: "image://theme/icon-cover-shuffle"; sourceBuddyIcon: ""; stateBuddyIcon: ""; page: "GroupsGetListGridPage.qml"; num: 0 }
        ListElement { tab: ""; sourcePlasceHolderIcon: "image://theme/icon-cover-timer"; sourceBuddyIcon: ""; stateBuddyIcon: ""; page: "PhotosGetContactsPhotosPage.qml"; num: 0 }
        ListElement { tab: ""; sourcePlasceHolderIcon: "image://theme/icon-cover-people"; sourceBuddyIcon: ""; stateBuddyIconcon: ""; page: "ContactsGetList.qml"; num: 0 }
        ListElement { tab: ""; sourcePlasceHolderIcon: "image://theme/icon-cover-sync"; sourceBuddyIcon: ""; stateBuddyIcon: ""; page: "PhotoListView.qml"; num: 0 }

        Component.onCompleted: {
            setProperty(0, "tab", peopleGetPhotosGridPage); setProperty(0, "stateBuddyIcon", loadingMessage)
            setProperty(1, "tab", peopleGetPublicPhotosPage); setProperty(0, "stateBuddyIcon", loadingMessage)
            setProperty(2, "tab", photosetsGetListGridPage); setProperty(0, "stateBuddyIcon", loadingMessage)
            setProperty(3, "tab", favoritesGetListPage); setProperty(0, "stateBuddyIcon", loadingMessage)
            setProperty(4, "tab", groupsGetListGridPage); setProperty(0, "stateBuddyIcon", loadingMessage)
            setProperty(5, "tab", photosGetContactsPhotosPage); setProperty(0, "stateBuddyIcon", loadingMessage)
            setProperty(6, "tab", contactsGetListPage); setProperty(0, "stateBuddyIcon", loadingMessage)
            setProperty(7, "tab", photoListView); setProperty(0, "stateBuddyIcon", loadingMessage)
        }
    }

    function peopleGetPhotosModelUpdate() {
        peopleGetPhotosInterface.queryApi(peopleGetPhotosModel.params)
    }

    function peopleGetPhotosModelChangePage(pageNumber) {
        peopleGetPhotosInterface.queryApi("page:" + pageNumber + ":" + peopleGetPhotosModel.params)
    }

    function peopleGetPublicPhotosModelUpdate() {
        peopleGetPublicPhotosInterface.queryApi("user_id:" + nsid  + ":" + peopleGetPublicPhotosModel.params)
    }

    function peopleGetPublicPhotosModelChangePage(pageNumber) {
        peopleGetPublicPhotosInterface.queryApi("page:" + pageNumber + ":" + peopleGetPublicPhotosModel.params)
    }

    function photosetsGetListModelUpdate() {
        photosetsGetListInterface.queryApi(photosetsGetListModel.params)
    }

    function photosetsGetListModelChangePage(pageNumber) {
        photosetsGetListInterface.queryApi("page:" + pageNumber + ":" + photosetsGetListModel.params)
    }

    function favoritesGetListModelUpdate() {
        favoritesGetListInterface.queryApi(favoritesGetListModel.params)
    }

    function favoritesGetListModelChangePage(pageNumber) {
        favoritesGetListInterface.queryApi("page:" + pageNumber + ":" + favoritesGetListModel.params)
    }

    function favoritesAddModelPhoto(photoId) {
        favoritesAddInterface.queryApi(favoritesAddModel.params + photoId)
    }

    function favoritesRemoveModelPhoto(photoId) {
        favoritesRemoveInterface.queryApi(favoritesRemoveModel.params + photoId)
    }

    function groupsGetListModelUpdate() {
        groupsGetListInterface.queryApi("user_id:" + nsid)
    }

    function photosGetContactsPhotosModelUpdate() {
        photosGetContactsPhotosInterface.queryApi(photosGetContactsPhotosModel.params)
    }

    function photosGetContactsPhotosModelChangePage(pageNumber) {
        photosGetContactsPhotosInterface.queryApi("page:" + pageNumber + ":" + photosGetContactsPhotosModel.params)
    }

    function contactsGetListModelUpdate() {
        contactsGetListInterface.queryApi("")
    }

    function photoGetRecentModelUpdate() {
        photoGetRecentInterface.queryApi(photoGetRecentModel.params)
    }

    function photoGetRecentModelUpdatePosition(coordinates) {
        photoGetRecentInterface.queryApi(coordinates + ":" + photoGetRecentModel.params)
        console.debug("model updated")
    }

    function photoGetRecentModelChangePage(pageNumber) {
        photoGetRecentInterface.queryApi("page:" + pageNumber + ":" + photoGetRecentModel.params)
    }

    function updateAllModel() {
        peopleGetPhotosModelUpdate()
        peopleGetPublicPhotosModelUpdate()
        photosetsGetListModelUpdate()
        favoritesGetListModelUpdate()
        groupsGetListModelUpdate()
        photosGetContactsPhotosModelUpdate()
        contactsGetListModelUpdate()
        photoGetRecentModelUpdate()
    }

    property var peopleGetPhotosInterface: FactoryModelInterface.getModelInterface(peopleGetPhotosModel.api + "&user_id:me:")

    property var peopleGetPublicPhotosInterface: FactoryModelInterface.getModelInterface(peopleGetPublicPhotosModel.api)

    property var photosetsGetListInterface: FactoryModelInterface.getModelInterface(photosetsGetListModel.api)

    property var photosetsListInterface: FactoryModelInterface.getModelInterface(photosetsGetPhotosModel.api)

    property var favoritesGetListInterface: FactoryModelInterface.getModelInterface(favoritesGetListModel.api)

    property var favoritesAddInterface: FactoryModelInterface.getModelInterface(favoritesAddModel.api)

    property var favoritesRemoveInterface: FactoryModelInterface.getModelInterface(favoritesRemoveModel.api)

    property var groupsGetListInterface: FactoryModelInterface.getModelInterface(groupsGetListModel.api)

    property var groupsListInterface: FactoryModelInterface.getModelInterface(groupGetPhotosModel.api)

    property var photosGetContactsPhotosInterface: FactoryModelInterface.getModelInterface(photosGetContactsPhotosModel.api)

    property var contactsGetListInterface: FactoryModelInterface.getModelInterface(contactsGetListModel.api)

    property var photoGetRecentInterface: FactoryModelInterface.getModelInterface(photoGetRecentModel.api)

    Connections {
        target: peopleGetPhotosInterface

        onXmlReady: {
            peopleGetPhotosModel.xml = xmlResponse
        }

        onFailed: {
            peopleGetPhotosModel.xml = ""
        }
    }

    Connections {
        target: peopleGetPublicPhotosInterface

        onXmlReady: {
            peopleGetPublicPhotosModel.xml = xmlResponse
        }

        onFailed: {
            peopleGetPublicPhotosModel.xml = ""
        }
    }

    Connections {
        target: photosetsGetListInterface

        onXmlReady: {
            photosetsGetListModel.xml = xmlResponse
        }

        onFailed: {
            photosetsGetListModel.xml = ""
        }
    }

    Connections {
        target: favoritesGetListInterface

        onXmlReady: {
            favoritesGetListModel.xml = xmlResponse
        }

        onFailed: {
            favoritesGetListModel.xml = ""
        }
    }

    Connections {
        target: favoritesAddInterface

        onXmlReady: {
            favoritesAddModel.xml = xmlResponse
            favoritesGetListModelUpdate()
        }

        onFailed: {
            favoritesAddModel.xml = ""
        }
    }

    Connections {
        target: favoritesRemoveInterface

        onXmlReady: {
            favoritesRemoveModel.xml = xmlResponse
            favoritesGetListModelUpdate()
        }

        onFailed: {
            favoritesRemoveModel.xml = ""
        }
    }

    Connections {
        target: groupsGetListInterface

        onXmlReady: {
            groupsGetListModel.xml = xmlResponse
        }

        onFailed: {
            groupsGetListModel.xml = ""
        }
    }

    Connections {
        target: photosGetContactsPhotosInterface

        onXmlReady: {
            photosGetContactsPhotosModel.xml = xmlResponse
        }

        onFailed: {
            photosGetContactsPhotosModel.xml = ""
        }
    }

    Connections {
        target: contactsGetListInterface

        onXmlReady: {
            contactsGetListModel.xml = xmlResponse
        }

        onFailed: {
            contactsGetListModel.xml = ""
        }
    }

    Connections {
        target: photoGetRecentInterface

        onXmlReady: {
            photoGetRecentModel.xml = xmlResponse
        }

        onFailed: {
            photoGetRecentModel.xml = ""
        }
    }

    PeopleGetPhotosModel {
        id: peopleGetPhotosModel

        onStatusChanged: {
            if (status === XmlListModel.Ready) {
                strStatus = count + " Items loaded";
                mainMenuModel.setProperty(0, "num", count)
                if (count > 0) {
                    mainMenuModel.setProperty(0, "sourceBuddyIcon", "https://farm" + get(0).farm + ".staticflickr.com/" + get(0).server + "/" + get(0).id + "_" + get(0).secret + "_t.jpg")
                    mainMenuModel.setProperty(0, "stateBuddyIcon", loadedMessage)
                }
            }
            if (status === XmlListModel.Loading) { strStatus = "Loading" }
            if (status === XmlListModel.Error) { strStatus = "Error:\n" + errorString }
            if (status === XmlListModel.Null) { strStatus = "Loading" }
        }
    }

    PeopleGetPublicPhotosModel {
        id: peopleGetPublicPhotosModel

        onStatusChanged: {
            if (status === XmlListModel.Ready) {
                strStatus = count + " Items loaded"
                mainMenuModel.setProperty(1, "num", count)
                if (count > 0) {
                    mainMenuModel.setProperty(1, "sourceBuddyIcon", "https://farm" + get(0).farm + ".staticflickr.com/" + get(0).server + "/" + get(0).id + "_" + get(0).secret + "_t.jpg")
                    mainMenuModel.setProperty(1, "stateBuddyIcon", loadedMessage)
                }
            }
            if (status === XmlListModel.Loading) { strStatus = "Loading" }
            if (status === XmlListModel.Error) { strStatus = "Error:\n" + errorString }
            if (status === XmlListModel.Null) { strStatus = "Loading" }
        }
    }

    PhotosetsGetListModel {
        id: photosetsGetListModel

        onStatusChanged: {
            if (status === XmlListModel.Ready) {
                strStatus = count + " Items loaded"
                mainMenuModel.setProperty(2, "num", count)
                photosetsListModel.loadData(0)
            }
            if (status === XmlListModel.Loading) { strStatus = "Loading" }
            if (status === XmlListModel.Error) { strStatus = "Error:\n" + errorString }
            if (status === XmlListModel.Null) { strStatus = "Loading" }
        }
    }

    PhotosetsGetPhotosModel {
        id: photosetsGetPhotosModel

        onStatusChanged: {
            if (status === XmlListModel.Ready) {
                strStatus = count + " Items loaded"
                if (photosetsListModel.iPhotosets === 0 && count > 0) {
                    mainMenuModel.setProperty(2, "sourceBuddyIcon", "https://farm" + get(0).farm + ".staticflickr.com/" + get(0).server + "/" + get(0).id + "_" + get(0).secret + "_t.jpg")
                    mainMenuModel.setProperty(2, "stateBuddyIcon", loadedMessage)
                }
                photosetsListModel.set(photosetsListModel.iPhotosets, { "id": photosetsGetListModel.get(photosetsListModel.iPhotosets).pId, title: photosetsGetListModel.get(photosetsListModel.iPhotosets).title, "xml": xml, "count": count, "urlFirstPhoto": "https://farm" + get(0).farm + ".staticflickr.com/" + get(0).server + "/" + get(0).id + "_" + get(0).secret + "_m.jpg" })
                photosetsListModel.iPhotosets++
                if (photosetsListModel.iPhotosets < photosetsGetListModel.count) {
                    photosetsListModel.loadData(photosetsListModel.iPhotosets)
                }
            }
            if (status === XmlListModel.Loading) { strStatus = "Loading" }
            if (status === XmlListModel.Error) { strStatus = "Error:\n" + errorString }
            if (status === XmlListModel.Null) { strStatus = "Loading" }
        }
    }

    ListModel {
        id: photosetsListModel
        property int iPhotosets: 0
        property bool changePage: false

        function loadData(idx) {
            iPhotosets = idx
            console.log("photosetsListModel.loadData - photoset_id:" + photosetsGetListModel.get(idx).pId + " idx:" + idx)
            photosetsListInterface.queryApi("photoset_id:" + photosetsGetListModel.get(idx).pId)
        }

        function fChangePage(pId, pageNumber) {
            console.log("photosetsListModel.loadData - photoset_id:" + pId)
            changePage = true
            photosetsListInterface.queryApi("photoset_id:" + pId + "page:" + pageNumber)
        }
    }

    Connections {
        target: photosetsListInterface

        onXmlReady: {
            photosetsGetPhotosModel.xml = xmlResponse
            photosetsListModel.changePage = false
            //console.log("photosetsListInterface - photosetsListModel.iPhotosets:" + photosetsListModel.iPhotosets)
            //photosetsListModel.set(photosetsListModel.iPhotosets, { "id": photosetsGetListModel.get(photosetsListModel.iPhotosets).pId, title: photosetsGetListModel.get(photosetsListModel.iPhotosets).title, "xml": photosetsGetPhotosModel.xml, "count": photosetsGetPhotosModel.count, "urlFirstPhoto": "https://farm" + photosetsGetPhotosModel.get(0).farm + ".staticflickr.com/" + photosetsGetPhotosModel.get(0).server + "/" + photosetsGetPhotosModel.get(0).id + "_" + photosetsGetPhotosModel.get(0).secret + "_m.jpg" })
        }

        onFailed: {
            photosetsGetPhotosModel.xml = ""
            photosetsListModel.changePage = false
        }
    }

    FavoritesGetListModel {
        id: favoritesGetListModel

        onStatusChanged: {
            if (status === XmlListModel.Ready) {
                strStatus = count + " Items loaded"
                mainMenuModel.setProperty(3, "num", count)
                if (count > 0) {
                    mainMenuModel.setProperty(3, "sourceBuddyIcon", "https://farm" + get(0).farm + ".staticflickr.com/" + get(0).server + "/" + get(0).id + "_" + get(0).secret + "_t.jpg")
                    mainMenuModel.setProperty(3, "stateBuddyIcon", loadedMessage)
                    Flib.loadFavoritesMap(favoritesGetListModel)
                }
            }
            if (status === XmlListModel.Loading) { strStatus = "Loading" }
            if (status === XmlListModel.Error) { strStatus = "Error:\n" + errorString }
            if (status === XmlListModel.Null) { strStatus = "Loading" }
        }
    }

    FavoritesAddModel {
        id: favoritesAddModel

        onStatusChanged: {
            if (status === XmlListModel.Ready) {
                strStatus = count + " Items loaded"
                /*
                mainMenuModel.setProperty(3, "num", count)
                if (count > 0) {
                    mainMenuModel.setProperty(3, "sourceBuddyIcon", "https://farm" + get(0).farm + ".staticflickr.com/" + get(0).server + "/" + get(0).id + "_" + get(0).secret + "_t.jpg")
                    mainMenuModel.setProperty(3, "stateBuddyIcon", loadedMessage)
                    Flib.loadFavoritesMap(favoritesAddModel)
                }
                */
            }
            if (status === XmlListModel.Loading) { strStatus = "Loading" }
            if (status === XmlListModel.Error) { strStatus = "Error:\n" + errorString }
            if (status === XmlListModel.Null) { strStatus = "Loading" }
        }
    }

    FavoritesRemoveModel {
        id: favoritesRemoveModel

        onStatusChanged: {
            if (status === XmlListModel.Ready) {
                strStatus = count + " Items loaded"
                /*
                mainMenuModel.setProperty(3, "num", count)
                if (count > 0) {
                    mainMenuModel.setProperty(3, "sourceBuddyIcon", "https://farm" + get(0).farm + ".staticflickr.com/" + get(0).server + "/" + get(0).id + "_" + get(0).secret + "_t.jpg")
                    mainMenuModel.setProperty(3, "stateBuddyIcon", loadedMessage)
                    Flib.loadFavoritesMap(favoritesRemoveModel)
                }
                */
            }
            if (status === XmlListModel.Loading) { strStatus = "Loading" }
            if (status === XmlListModel.Error) { strStatus = "Error:\n" + errorString }
            if (status === XmlListModel.Null) { strStatus = "Loading" }
        }
    }

    GroupsGetListModel {
        id: groupsGetListModel

        onStatusChanged: {
            if (status === XmlListModel.Ready) {
                strStatus = count + " Items loaded"
                mainMenuModel.setProperty(4, "num", count)
                groupsListModel.loadData(0)
            }
            if (status === XmlListModel.Loading) { strStatus = "Loading" }
            if (status === XmlListModel.Error) { strStatus = "Error:\n" + errorString }
            if (status === XmlListModel.Null) { strStatus = "Loading" }
        }
    }

    GroupGetPhotosModel {
        id: groupGetPhotosModel

        onStatusChanged: {
            if (status === XmlListModel.Ready) {
                strStatus = count + " Items loaded"
                if (groupsListModel.iGroups === 0 && count > 0) {
                    mainMenuModel.setProperty(4, "sourceBuddyIcon", "https://farm" + get(0).farm + ".staticflickr.com/" + get(0).server + "/" + get(0).id + "_" + get(0).secret + "_t.jpg")
                    mainMenuModel.setProperty(4, "stateBuddyIcon", loadedMessage)
                }
                groupsListModel.set(groupsListModel.iGroups, { "id": groupsGetListModel.get(groupsListModel.iGroups).nsid, name: groupsGetListModel.get(groupsListModel.iGroups).name, "xml": xml, "count": count, "urlFirstGroup": "https://farm" + get(0).farm + ".staticflickr.com/" + get(0).server + "/" + get(0).id + "_" + get(0).secret + "_m.jpg" })
                groupsListModel.iGroups++
                if (groupsListModel.iGroups < groupsGetListModel.count) {
                    groupsListModel.loadData(groupsListModel.iGroups)
                }
            }
            if (status === XmlListModel.Loading) { strStatus = "Loading" }
            if (status === XmlListModel.Error) { strStatus = "Error:\n" + errorString }
            if (status === XmlListModel.Null) { strStatus = "Loading" }
        }
    }

    ListModel {
        id: groupsListModel
        property int iGroups: 0
        property bool changePage: false

        function loadData(idx) {
            iGroups = idx
            console.log("groupsListModel.loadData - group_id:" + groupsGetListModel.get(idx).nsid + " idx:" + idx)
            groupsListInterface.queryApi("group_id:" + groupsGetListModel.get(idx).nsid)
        }

        function fChangePage(gnsid, pageNumber) {
            console.log("groupsListModel.loadData - group_id:" + gnsid)
            changePage = true
            groupsListInterface.queryApi("group_id:" + gnsid + ":page:" + pageNumber)
        }

        /*
        function changePage(idx, page) {
            iGroups = idx
            console.log("groupsListModel.loadData - group_id:" + groupsGetListModel.get(idx).nsid + " idx:" + idx)
            groupsListInterface.queryApi("group_id:" + groupsGetListModel.get(idx).nsid)
        }
        */
    }

    Connections {
        target: groupsListInterface

        onXmlReady: {
            groupGetPhotosModel.xml = xmlResponse
            groupsListModel.changePage = false
            //console.log("groupsListInterface - groupsListModel.iGroups:" + groupsListModel.iGroups)
            //groupsListModel.set(groupsListModel.iGroups, { "id": groupsGetListModel.get(groupsListModel.iGroups).nsid, name: groupsGetListModel.get(groupsListModel.iGroups).name, "xml": groupGetPhotosModel.xml, "count": groupGetPhotosModel.count, "urlFirstGroup": "https://farm" + groupGetPhotosModel.get(0).farm + ".staticflickr.com/" + groupGetPhotosModel.get(0).server + "/" + groupGetPhotosModel.get(0).id + "_" + groupGetPhotosModel.get(0).secret + "_m.jpg" })
        }

        onFailed: {
            groupGetPhotosModel.xml = ""
            groupsListModel.changePage = false
        }
    }

    PhotosGetContactsPhotosModel {
        id: photosGetContactsPhotosModel

        onStatusChanged: {
            if (status === XmlListModel.Ready) {
                strStatus = count + " Items loaded"
                mainMenuModel.setProperty(5, "num", count)
                if (count > 0) {
                    mainMenuModel.setProperty(5, "sourceBuddyIcon", "https://farm" + get(0).farm + ".staticflickr.com/" + get(0).server + "/" + get(0).id + "_" + get(0).secret + "_t.jpg")
                    mainMenuModel.setProperty(5, "stateBuddyIcon", loadedMessage)
                }
            }
            if (status === XmlListModel.Loading) { strStatus = "Loading" }
            if (status === XmlListModel.Error) { strStatus = "Error:\n" + errorString }
            if (status === XmlListModel.Null) { strStatus = "Loading" }
            console.log(strStatus)
        }
    }

    ContactsGetListModel {
        id: contactsGetListModel

        onStatusChanged: {
            if (status === XmlListModel.Ready) {
                strStatus = count + " Items loaded"
                mainMenuModel.setProperty(6, "num", count)
                if (count > 0) {
                    mainMenuModel.setProperty(6, "sourceBuddyIcon", "https://farm" + get(0).iconfarm + ".staticflickr.com/" + get(0).iconserver + "/buddyicons/" + get(0).nsid + ".jpg")
                    mainMenuModel.setProperty(6, "stateBuddyIcon", loadedMessage)
                }
            }
            if (status === XmlListModel.Loading) { strStatus = "Loading" }
            if (status === XmlListModel.Error) { strStatus = "Error:\n" + errorString }
            if (status === XmlListModel.Null) { strStatus = "Loading" }
        }
    }

    PhotoGetRecentModel {
        id: photoGetRecentModel

        onStatusChanged: {
            if (status === XmlListModel.Ready) {
                strStatus = count + " Items loaded"
                mainMenuModel.setProperty(7, "num", count)
                if (count > 0) {
                    mainMenuModel.setProperty(7, "sourceBuddyIcon", "https://farm" + get(0).farm + ".staticflickr.com/" + get(0).server + "/" + get(0).id + "_" + get(0).secret + "_t.jpg")
                    mainMenuModel.setProperty(7, "stateBuddyIcon", loadedMessage)
                }
            }
            if (status === XmlListModel.Loading) { strStatus = "Loading" }
            if (status === XmlListModel.Error) { strStatus = "Error:\n" + errorString }
            if (status === XmlListModel.Null) { strStatus = "Loading" }
        }
    }
}


