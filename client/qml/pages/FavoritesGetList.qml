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
        anchors.fill: parent
        clip: true

        PullDownMenu {
            busy: favoritesGetListModel.loading
            MenuItem {
                //enabled: favoritesGetListModel.page > 1
                visible: favoritesGetListModel.page > 1
                text: qsTr("Previous page")
                onClicked: { favoritesGetListModelChangePage(--favoritesGetListModel.page); favoritesGetListModelTimer.start() }
            }
            MenuItem {
                text: qsTr("Update")
                onClicked: { favoritesGetListModelUpdate(); favoritesGetListModelTimer.start() }
            }
        }

        PushUpMenu {
            busy: favoritesGetListModel.loading
            MenuItem {
                enabled: favoritesGetListModel.pages > favoritesGetListModel.page
                text: qsTr("Next page")
                onClicked: { favoritesGetListModelChangePage(++favoritesGetListModel.page); favoritesGetListModelTimer.start() }
            }
        }

        header: PageHeader { title: page.title }

        cellWidth: width / 3
        cellHeight: cellWidth
        cacheBuffer: grid.height
        model: favoritesGetListModel

        delegate: JockrImage {
            width: grid.cellWidth
            height: grid.cellHeight
            source: "https://farm" + farm + ".staticflickr.com/" + server + "/" + id + "_" + secret + "_q.jpg"
            onClick: pageStack.push(Qt.resolvedUrl("FlickrSlideView.qml"), {currentIndex: index, model: grid.model} )
        }

        ScrollDecorator {}

        ViewPlaceholder {
            enabled: grid.count == 0
            text: favoritesGetListModel.strStatus
        }
    }


}
