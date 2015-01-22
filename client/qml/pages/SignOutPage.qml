import QtQuick 2.0
import Sailfish.Silica 1.0
import QtWebKit 3.0

Page {
    id: root
    property alias webUrl: webView.url
    property int firstSignOut: 0
    width: parent.width
    height: parent.height

    WebView {
        id: webView
        anchors.fill: parent
        visible: url != ""
        width: parent.width * 4
        height: parent.width * 4

        onLoadingChanged: {
            if (loadRequest.status === WebView.LoadStartedStatus) {
                console.debug("Loading started...");
            }
            if (loadRequest.status === WebView.LoadSucceededStatus) {
                console.log("Page loaded!");
                if (firstSignOut > 0) {
                    peopleGetPhotosModel.xml = ""
                    peopleGetPublicPhotosModel.xml = ""
                    photosetsGetListModel.xml = ""
                    favoritesGetListModel.xml = ""
                    groupsGetListModel.xml = ""
                    photosGetContactsPhotosModel.xml = ""
                    contactsGetListModel.xml = ""
                    photoGetRecentModel.xml = ""
                    groupGetPhotosModel.xml = ""

                    pageStack.pop(window.initialPage)
                }
                else {
                    firstSignOut++
                }
            }
            if (loadRequest.status === WebView.LoadFailedStatus) {
                console.debug("Load failed! Error code: " + loadRequest.errorCode);
                if (loadRequest.errorCode === NetworkReply.OperationCanceledError)
                    console.debug("Load cancelled by user");
            }
        }
    }
}
