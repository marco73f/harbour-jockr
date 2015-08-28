import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import harbour.jockr 1.0

XmlListModel {
    property string api: "flickr.favorites.getList"
    property string params: "extras:url_s,owner_name:per_page:" + GValue.per_page // + ":page:" + GValue.page
    property string strStatus
    property int page: 1
    property int pages: 10

    query: "/rsp/photos/photo"

    XmlRole { name: "id"; query: "@id/string()" }
    XmlRole { name: "owner"; query: "@owner/string()" }
    XmlRole { name: "ownername"; query: "@ownername/string()" }
    XmlRole { name: "secret"; query: "@secret/string()" }
    XmlRole { name: "server"; query: "@server/string()" }
    XmlRole { name: "farm"; query: "@farm/string()" }
    XmlRole { name: "title"; query: "@title/string()" }
    XmlRole { name: "url_s"; query: "@url_s/string()" }
    XmlRole { name: "height"; query: "@height_m/string()" }
    XmlRole { name: "width"; query: "@width_m/string()" }


}
