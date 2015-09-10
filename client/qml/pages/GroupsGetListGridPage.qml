import QtQuick 2.0
import Sailfish.Silica 1.0
import "models"
import "delegates"
import harbour.jockr 1.0

Page {
    id: page
    property string title

    SilicaGridView {
        id: grid
        header: PageHeader { title: page.title }
        cellWidth: width / 2
        cellHeight: cellWidth + Theme.itemSizeExtraSmall
        cacheBuffer: grid.height
        anchors.fill: parent
        model: groupsListModel

//        PullDownMenu {
//            busy: groupsListModel.loading
//            MenuItem {
//                text: qsTr("Update")
//                onClicked: {
//                    groupsListModelUpdate()
//                    groupsListModelTimer.start()
//                }
//            }
//        }

        delegate: JockrPhotoset {
            width: grid.cellWidth
            height: grid.cellHeight
            source: urlFirstGroup
            photosetId: id
            albumTitle: name
            onClick: pageStack.push(Qt.resolvedUrl("GroupsGetPhotosGridPage.qml"), { group_Title: name, group_id: id, group_xml: xml } )
        }

        ScrollDecorator {}

        ViewPlaceholder {
            enabled: grid.count == 0
        }
    }
}

