import QtQuick 2.0
import Sailfish.Silica 1.0
import QtWebKit 3.0

Page {
    id: root
    property alias webUrl: webView.url
    width: parent.width
    height: parent.height

    WebView {
        id: webView
        anchors.fill: parent
        visible: url != ""
    }
}
