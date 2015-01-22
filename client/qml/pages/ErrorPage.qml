import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    anchors.fill: parent

    Column {
        id: pageColumn
        anchors.centerIn: parent
        spacing: Theme.paddingMedium

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Error Page")
            font.bold: true
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Not connected")
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Reload")
        }
    }
}
