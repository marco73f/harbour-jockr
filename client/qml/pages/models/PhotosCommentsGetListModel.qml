import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import harbour.jockr 1.0

XmlListModel {
    property string api: "flickr.photos.comments.getList"
    property string params
    property string strStatus

    query: "/rsp/comments/comment"

    XmlRole { name: "id"; query: "@id/string()" }
    XmlRole { name: "author"; query: "@author/string()" }
    XmlRole { name: "authorname"; query: "@authorname/string()" }
    XmlRole { name: "datecreate"; query: "@datecreate/number()" }
    XmlRole { name: "comment"; query: "string()" }
    XmlRole { name: "link"; query: "@permalink/string()" }

    onStatusChanged: {
        if (status === XmlListModel.Ready) { strStatus = count + " Items loaded" }
        if (status === XmlListModel.Loading) { strStatus = "Loading" }
        if (status === XmlListModel.Error) { strStatus = "Error:\n" + errorString }
        if (status === XmlListModel.Null) { strStatus = "Loading" }
    }
}
