import QtQuick 2.0
import Sailfish.Silica 1.0
import Jockr 1.0


Page {
    id: settings

    SilicaFlickable {
        id: flick
        anchors.fill: parent
        contentHeight: contentColumn.height
        contentWidth: flick.width

        Column {
            id: contentColumn
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("Settings")
            }

            Text {
                id:textEditor
                width: parent.width
                color: Theme.primaryColor
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeMedium
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Disconnect")
                onClicked: OAuth.disconnect()
            }
        }
    }
}
