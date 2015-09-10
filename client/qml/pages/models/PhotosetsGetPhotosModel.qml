import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import harbour.jockr 1.0

XmlListModel {
    property string api: "flickr.photosets.getPhotos"
    property string params
    property string photosetId
    property string strStatus
    property int page: 0
    property int pages: 10
    property bool loading: false

    query: "/rsp/photoset/photo"

    XmlRole { name: "id"; query: "@id/string()" }
    XmlRole { name: "secret"; query: "@secret/string()" }
    XmlRole { name: "server"; query: "@server/string()" }
    XmlRole { name: "farm"; query: "@farm/string()" }
    XmlRole { name: "title"; query: "@title/string()" }
    XmlRole { name: "isprimary"; query: "@isprimary/string()" }
}

