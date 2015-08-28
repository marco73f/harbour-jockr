import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import harbour.jockr 1.0

XmlListModel {
    property string api: "flickr.people.getGroups"
    property string params
    property string strStatus

    query: "/rsp/groups/group"

    XmlRole { name: "nsid"; query: "@nsid/string()" }
    XmlRole { name: "name"; query: "@name/string()" }
    XmlRole { name: "iconfarm"; query: "@iconfarm/string()" }
    XmlRole { name: "iconserver"; query: "@iconserver/string()" }

    onStatusChanged: {
        if (status === XmlListModel.Ready) { strStatus = count + " Items loaded" }
        if (status === XmlListModel.Loading) { strStatus = "Loading" }
        if (status === XmlListModel.Error) { strStatus = "Error:\n" + errorString }
        if (status === XmlListModel.Null) { strStatus = "Loading" }
    }
}

