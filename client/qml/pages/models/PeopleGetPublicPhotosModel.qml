import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import Jockr 1.0

XmlListModel {
    property string api: "flickr.people.getPublicPhotos"
    property string params: "extras:owner_name,url_m,url_s:per_page:" + GValue.per_page + ":page:" + GValue.page
    property string nsid
    property string strStatus

    query: "/rsp/photos/photo"

    XmlRole { name: "owner"; query: "@owner/string()" }
    XmlRole { name: "url_m"; query: "@url_m/string()" }
    XmlRole { name: "url_s"; query: "@url_s/string()" }
    XmlRole { name: "ownername"; query: "@owner_name/string()" }
    XmlRole { name: "server"; query: "@server/string()" }
    XmlRole { name: "farm"; query: "@farm/string()" }
    XmlRole { name: "id"; query: "@id/string()" }
    XmlRole { name: "secret"; query: "@secret/string()" }

}
