import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0
import Jockr 1.0
import "delegates"
import "models"

Page {
    id: page

    SilicaListView {
        id: listView
        anchors {
            fill: parent
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
            }
            MenuItem {
                text: "Settings"
                onClicked: pageStack.push(Qt.resolvedUrl("Settings.qml"))
            }
            MenuItem {
                text: qsTr("update view")
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
            stateIcon: stateBuddyIcon
        }

        model: mainMenuModel
    }
}


