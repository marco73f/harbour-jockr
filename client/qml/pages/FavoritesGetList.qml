import QtQuick 2.0
import Sailfish.Silica 1.0
import "models"
import "delegates"
import Jockr 1.0

Page {
    id: page
    anchors.fill: parent
    property string title

    SilicaGridView {
        id: grid
        anchors.fill: parent
        clip: true

        PullDownMenu {
            MenuItem {
                text: qsTr("Update")
                onClicked: {
                    favoritesGetListModelUpdate()
                    console.debug("Update clicked")
                }
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
