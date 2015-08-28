import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import harbour.jockr 1.0

XmlListModel {
    property string api: "flickr.people.getPhotos"
    property string nsid
    property string params: "extras:description,license,date_upload,date_taken,owner_name,icon_server,original_format,last_update,geo,tags,machine_tags,views"
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
    XmlRole { name: "ispublic"; query: "@ispublic/string()" }
    XmlRole { name: "isfriend"; query: "@isfriend/string()" }
    XmlRole { name: "isfamily"; query: "@isfamily/string()" }
    XmlRole { name: "description"; query: "@description/string()" }
    XmlRole { name: "license"; query: "@license/string()" }
    XmlRole { name: "tags"; query: "@tags/string()" }
    XmlRole { name: "latitude"; query: "@latitude/string()" }
    XmlRole { name: "longitude"; query: "@longitude/string()" }
    XmlRole { name: "dateupload"; query: "@dateupload/string()" }
}
