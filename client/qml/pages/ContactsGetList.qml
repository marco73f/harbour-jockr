import QtQuick 2.0
import Sailfish.Silica 1.0
import "models"
import "delegates"
import harbour.jockr 1.0

Page {
    id: page
    property string title

    SilicaListView {
        id: contactList
        header: PageHeader { title: page.title }



        anchors.fill: parent


        PullDownMenu {
            busy: contactsGetListModel.loading
            MenuItem {
                text: qsTr("Update")
                onClicked: {
                    contactsGetListModelUpdate()
                    contactsGetListModelTimer.start()
                }
            }
        }

        delegate: BackgroundItem {
            width: ListView.view.width
            height: Theme.itemSizeMedium
            onClicked: pageStack.push(Qt.resolvedUrl("ContactsGetPhotosGridPage.qml"), { nsId: nsid, title: username })
            JockrBuddyIcon {
                id: buddyIcon
                iconFarm: iconfarm
                iconServer: iconserver
                nsId: nsid
                userName: username
                realName: realname
                clr: highlighted ? Theme.highlightColor : Theme.primaryColor
            }
        }
        model: contactsGetListModel
        cacheBuffer: contactList.height
        ScrollDecorator {}

        ViewPlaceholder {
            enabled: contactList.count == 0
            text: contactsGetListModel.strStatus
        }
    }
}
