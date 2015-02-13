import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: aboutPage

    SilicaFlickable {
        id: flickable
        anchors.fill: parent

        VerticalScrollDecorator { flickable: flickable }

        contentWidth: aboutColumn.width
        contentHeight: aboutColumn.height + aboutColumn.spacing

        Column {
            id: aboutColumn

            width: aboutPage.width
            spacing: Theme.paddingMedium


            PageHeader {
                title: qsTr("About")
            }

            Column {
                spacing: Theme.paddingLarge

                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingLarge
                }

                Label {
                    text: "Jockr - 0.0.1-1"
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeMedium/usr/share/harbour-jockr/usr/share/harbour-jockr
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                }

                Label {
                    text: qsTr("Donations are welcome")
                    font.pixelSize: Theme.fontSizeMedium
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                }

                Row {
                    height: Theme.itemSizeLarge
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                    }
                    spacing: Theme.paddingLarge

                    Button {
                        text: "PayPal EUR"
                        anchors.verticalCenter: parent.verticalCenter
                        onClicked: {
                            Qt.openUrlExternally("https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=marco73f%40gmail%2ecom&lc=US&item_name=Donation%20for%20Jockr%20EUR&no_note=0&currency_code=EUR&bn=PP%2dDonationsBF%3abtn_donate_SM%2egif%3aNonHostedGuest")
                        }
                    }


                    Button {
                        text: "PayPal USD"
                        anchors.verticalCenter: parent.verticalCenter
                        onClicked: {
                            Qt.openUrlExternally("https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=marco73f%40gmail%2ecom&lc=US&item_name=Donation%20for%20Jockr%20USD&no_note=0&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donate_SM%2egif%3aNonHostedGuest")
                        }
                    }

                }

                Label {
                    text: qsTr("You are welcome to contribute to translations")
                    font.pixelSize: Theme.fontSizeMedium
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                }

                Button {
                    text: "Transifex"
                    width: 300
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        Qt.openUrlExternally("https://www.transifex.com/projects/p/jockr/")
                    }
                }

                Label {
                    text: qsTr("Author: %1").arg("Marco Forte")
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeMedium
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                }

                Button {
                    text: "Twitter"
                    width: 300
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        Qt.openUrlExternally("https://twitter.com/marco73f")
                    }
                }

                Button {
                    text: "e-mail"
                    width: 300
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        Qt.openUrlExternally("mailto:marco73f@gmail.com?subject=Jockr")
                    }
                }

                Button {
                    text: "LinkedIn"
                    width: 300
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        Qt.openUrlExternally("http://it.linkedin.com/pub/marco-forte/93/63a/a2a")
                    }
                }
            }
        }
    }
}
