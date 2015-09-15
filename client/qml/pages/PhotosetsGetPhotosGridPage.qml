import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0
import "models"
import "delegates"
import harbour.jockr 1.0

Page {
    id: page
    property string photoset_Id
    property string album_Title
    property string photoset_xml

    property bool justOpened: false

    property var modelInterface: FactoryModelInterface.getModelInterface(photosetListModel.api + "&photoset_id:" + photoset_Id + ":")

    onStatusChanged: {
        if (status === PageStatus.Active) {
            if (!justOpened) { photosetListModel.xml = photoset_xml }
            justOpened = true
        }
    }

    Connections {
        target: modelInterface

        onXmlReady: {
            photosetListModel.xml = xmlResponse
        }

        onFailed: {
            photosetListModel.xml = ""
        }
    }

    PhotosetsGetPhotosModel {
        id: photosetListModel
        property int lpage: 1

        onStatusChanged: {
            if (status === XmlListModel.Ready) { strStatus = count + qsTr(" Items loaded") }
            if (status === XmlListModel.Loading) { strStatus = qsTr("Loading") }
            if (status === XmlListModel.Error) { strStatus = qsTr("Error:") + "\n" + errorString }
            if (status === XmlListModel.Null) { strStatus = qsTr("Loading") }
        }
    }

    function photosetListModelChangePage(pageNumber) {
        modelInterface.queryApi("page:" + pageNumber)
    }

    Timer {
        id: photosetListModelTimer
        interval: 2000
        running: false
        repeat: false
        triggeredOnStart: true
        onTriggered: photosetListModel.loading = !photosetListModel.loading
    }

    SilicaGridView {
        id: grid
        header: PageHeader { title: page.album_Title }
        cellWidth: width / 3
        cellHeight: cellWidth
        cacheBuffer: grid.height
        anchors.fill: parent
        model: photosetListModel

        PullDownMenu {
            busy: photosetsGetPhotosModel.loading
            MenuItem {
                visible: photosetListModel.lpage > 1
                text: qsTr("Previous page")
                onClicked: { photosetListModelChangePage(--photosetsGetPhotosModel.lpage); photosetListModelTimer.start() }
            }
            MenuItem {
                text: qsTr("Update")
                onClicked: { photosetListModelChangePage(photosetsGetPhotosModel.lpage); photosetListModelTimer.start() }
            }
        }

        PushUpMenu {
            busy: photosetsGetPhotosModel.loading
            MenuItem {
                enabled: photosetListModel.pages > photosetListModel.lpage && photosetListModel.count >= GValue.per_page
                text: qsTr("Next page")
                onClicked: {
                    photosetListModelChangePage(++photosetsGetPhotosModel.page)
                    photosetListModel.xml = ""
                    photosetListModelTimer.start()
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
    }
}

