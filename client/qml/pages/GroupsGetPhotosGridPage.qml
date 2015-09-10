import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0
import "models"
import "delegates"
import harbour.jockr 1.0

Page {
    id: page
    property string group_id
    property string group_Title
    property string group_xml
    property alias model: grid.model

    property var modelInterface: FactoryModelInterface.getModelInterface(groupPageListModel.api)

    onStatusChanged: {
        if (status === PageStatus.Active) {
            groupPageListModel.xml = group_xml
        }
    }

    Connections {
        target: modelInterface

        onXmlReady: {
            groupPageListModel.xml = xmlResponse
        }

        onFailed: {
            groupPageListModel.xml = ""
        }
    }

    GroupGetPhotosModel {
        id: groupPageListModel
        property int lpage: 1

        onStatusChanged: {
            if (status === XmlListModel.Ready) { strStatus = count + qsTr(" Items loaded") }
            if (status === XmlListModel.Loading) { strStatus = qsTr("Loading") }
            if (status === XmlListModel.Error) { strStatus = qsTr("Error:") + "\n" + errorString }
            if (status === XmlListModel.Null) { strStatus = qsTr("Loading") }
        }
    }

    function groupPageListModelChangePage(pageNumber) {
        modelInterface.queryApi("group_id:" + group_id + ":page:" + pageNumber)
    }

    Timer {
        id: groupPageListModelTimer
        interval: 2000
        running: false
        repeat: false
        triggeredOnStart: true
        onTriggered: groupPageListModel.loading = !groupPageListModel.loading
    }

    SilicaGridView {
        id: grid
        header: PageHeader { title: page.group_Title }
        cellWidth: width / 3
        cellHeight: cellWidth
        cacheBuffer: grid.height
        anchors.fill: parent
        model: groupPageListModel

        PullDownMenu {
            busy: groupPageListModel.loading
            MenuItem {
                visible: groupPageListModel.lpage > 1
                text: qsTr("Previous page")
                onClicked: { groupPageListModelChangePage(--groupPageListModel.lpage); groupPageListModelTimer.start() }
            }
            MenuItem {
                text: qsTr("Update")
                onClicked: { groupPageListModelChangePage(groupPageListModel.lpage); groupPageListModelTimer.start() }
            }
        }

        PushUpMenu {
            busy: groupPageListModel.loading
            MenuItem {
                enabled: groupPageListModel.pages > groupPageListModel.lpage
                text: qsTr("Next page")
                onClicked: { groupPageListModelChangePage(++groupPageListModel.lpage); groupPageListModelTimer.start() }
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

