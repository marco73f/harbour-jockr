import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import harbour.jockr 1.0

XmlListModel {
    property string api: "flickr.photos.getContactsPublicPhotos"
    property string params: "user_id:89036220@N08:count:20:include_self:1:single_photo:true"
    property string strStatus
    property bool loading: false

    Component.onCompleted: {
        loadData()
    }

    function loadData() {
        Requestor.queryApi("method:" + api + ":" + params)
    }

    query: "/rsp/photos/photo"

    XmlRole { name: "owner"; query: "@owner/string()" }
    XmlRole { name: "title"; query: "@title/string()" }
    XmlRole { name: "username"; query: "@username/string()" }
    XmlRole { name: "datetaken"; query: "@datetaken/string()" }
    XmlRole { name: "farm"; query: "@farm/string()" }
    XmlRole { name: "server"; query: "@server/string()" }
    XmlRole { name: "id"; query: "@id/string()" }
    XmlRole { name: "secret"; query: "@secret/string()" }

    onStatusChanged: {
        if (status === XmlListModel.Ready) { strStatus = count + " Items loaded" }
        if (status === XmlListModel.Loading) { strStatus = "Loading" }
        if (status === XmlListModel.Error) { strStatus = "Error:\n" + errorString }
        if (status === XmlListModel.Null) { strStatus = "Loading" }
    }
}
