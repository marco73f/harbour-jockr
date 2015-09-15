import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0
import "delegates"
import "models"
import harbour.jockr 1.0

Page {
    id: page;
    width: parent.width
    height: parent.width
    property bool inListView: false

    Connections {
        target: Requestor

        onXmlReady: {
            photosGetContactsPhotosModel.xml = xmlResponse
        }

        onFailed: {
            photosGetContactsPhotosModel.xml = ""
        }
    }

    PhotosGetContactsPhotosModel {
        id: photosGetContactsPhotosModel
    }

    DefaultGridDelegate { id: gridDelegate }
    GridView {
        x: (width/4-79)/2; y: x
        id: photoGridView
        model: photosGetContactsPhotosModel
        delegate: gridDelegate
        cacheBuffer: 100
        cellWidth: (parent.width-2)/4
        cellHeight: cellWidth
        width: parent.width
        height: parent.height - 1
        z: 6
    }

    DefaultListDelegate { id: listDelegate }

    ListView {
        id: photoListView
        model: photosGetContactsPhotosModel
        delegate: listDelegate
        z: 6
        width: parent.width
        height: parent.height
        x: -(parent.width * 1.5)
        cacheBuffer: 100
    }

    states: State {
        name: "ListView"; when: page.inListView == true
        PropertyChanges { target: photoListView; x: 0 }
        PropertyChanges { target: photoGridView; x: -(parent.width * 1.5) }
    }

    transitions: Transition {
        NumberAnimation { properties: "x"; duration: 500; easing.type: Easing.InOutQuad }
    }
}
