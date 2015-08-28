import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import harbour.jockr 1.0

XmlListModel {
    property string api: "flickr.photosets.getList"
    property string params
    property string strStatus
    property int page: 1
    property int pages: 10

    query: "/rsp/photosets/photoset"

    XmlRole { name: "pId"; query: "@id/string()" }
    XmlRole { name: "primary"; query: "@primary/string()" }
    XmlRole { name: "secret"; query: "@secret/string()" }
    XmlRole { name: "server"; query: "@server/string()" }
    XmlRole { name: "farm"; query: "@farm/string()" }
    XmlRole { name: "photos"; query: "@photos/string()" }
    XmlRole { name: "videos"; query: "@videos/string()" }
    XmlRole { name: "needs_interstitial"; query: "@needs_interstitial/string()" }
    XmlRole { name: "visibility_can_see_set"; query: "@visibility_can_see_set/string()" }
    XmlRole { name: "count_comments"; query: "@count_comments/string()" }
    XmlRole { name: "can_comment"; query: "@can_comment/string()" }
    XmlRole { name: "count_views"; query: "@count_views/string()" }
    XmlRole { name: "date_create"; query: "@date_create/string()" }
    XmlRole { name: "date_update"; query: "@date_update/string()" }
    XmlRole { name: "title"; query: "title/string()" }
    XmlRole { name: "description"; query: "description/string()" }

}

