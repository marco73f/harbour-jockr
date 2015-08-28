import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import harbour.jockr 1.0

XmlListModel {
    property string api: "flickr.groups.pools.getPhotos"
    property string params
    property string grouptId
    property string strStatus
    property int page: 0
    property int pages: 10

    query: "/rsp/photos/photo"

    XmlRole { name: "id"; query: "@id/string()" }
    XmlRole { name: "owner"; query: "@owner/string()" }
    XmlRole { name: "secret"; query: "@secret/string()" }
    XmlRole { name: "server"; query: "@server/string()" }
    XmlRole { name: "farm"; query: "@farm/string()" }
    XmlRole { name: "title"; query: "@title/string()" }

    onStatusChanged: {
        if (status === XmlListModel.Ready) { strStatus = count + " Items loaded" }
        if (status === XmlListModel.Loading) { strStatus = "Loading" }
        if (status === XmlListModel.Error) { strStatus = "Error:\n" + errorString }
        if (status === XmlListModel.Null) { strStatus = "Loading" }
    }
}

