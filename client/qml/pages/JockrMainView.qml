import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0
import harbour.jockr 1.0
import "delegates"
import "models"

Page {
    id: page

    Timer {
        id: peopleGetPhotosModelTimer
        interval: 2000
        running: false
        repeat: false
        triggeredOnStart: true
        onTriggered: peopleGetPhotosModel.loading = !peopleGetPhotosModel.loading
    }

    SilicaListView {
        id: listView
        anchors {
            fill: parent
        }

        PullDownMenu {
            busy: mainMenuModel.loading
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
            }
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("Settings.qml"))
            }
            MenuItem {
                text: qsTr("Update view")
                onClicked: updateAllModel()
            }
        }

        header: PageHeader {
            title: "Jockr"
        }

        delegate: JockrBuddyPhoto {
            width: ListView.view.width
            height: Theme.itemSizeMedium
            onClicked: pageStack.push(Qt.resolvedUrl(page), { title: tab })
            tabLabel: tab
            numberItem: num
            placeHolderIcon: sourcePlasceHolderIcon
            sourceIcon: sourceBuddyIcon
//            stateIcon: stateBuddyIcon
        }

        model: mainMenuModel
    }
}


