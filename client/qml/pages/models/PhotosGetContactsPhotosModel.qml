import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import harbour.jockr 1.0

XmlListModel {
    property string api: "flickr.photos.getContactsPhotos"
    property string params: "extras:description,license,date_upload,date_taken,owner_name,icon_server,original_format,last_update,geo,tags,machine_tags"
    property string strStatus
    property int page: 1
    property int pages: 10
    property bool loading: false

    query: "/rsp/photos/photo"

    XmlRole { name: "id"; query: "@id/string()" }
    XmlRole { name: "secret"; query: "@secret/string()" }
    XmlRole { name: "server"; query: "@server/string()" }
    XmlRole { name: "farm"; query: "@farm/string()" }
    XmlRole { name: "owner"; query: "@owner/string()" }
    XmlRole { name: "username"; query: "@username/string()" }
    XmlRole { name: "title"; query: "@title/string()" }
    XmlRole { name: "ispublic"; query: "@ispublic/string()" }
    XmlRole { name: "description"; query: "@description/string()" }
    XmlRole { name: "isfriend"; query: "@isfriend/string()" }
    XmlRole { name: "isfamily"; query: "@isfamily/string()" }
    XmlRole { name: "license"; query: "@license/string()" }
    XmlRole { name: "dateupload"; query: "@dateupload/string()" }
    XmlRole { name: "lastupdate"; query: "@lastupdate/string()" }
    XmlRole { name: "datetaken"; query: "@datetaken/string()" }
    XmlRole { name: "datetakengranularity"; query: "@datetakengranularity/string()" }
    XmlRole { name: "ownername"; query: "@ownername/string()" }
    XmlRole { name: "iconserver"; query: "@iconserver/string()" }
    XmlRole { name: "iconfarm"; query: "@iconfarm/string()" }
    XmlRole { name: "tags"; query: "@tags/string()" }
    XmlRole { name: "machine_tags"; query: "@machine_tags/string()" }
    XmlRole { name: "originalsecret"; query: "@originalsecret/string()" }
    XmlRole { name: "originalformat"; query: "@originalformat/string()" }
    XmlRole { name: "latitude"; query: "@latitude/string()" }
    XmlRole { name: "longitude"; query: "@longitude/string()" }
    XmlRole { name: "accuracy"; query: "@accuracy/string()" }
    XmlRole { name: "context"; query: "@context/string()" }
    XmlRole { name: "place_id"; query: "@place_id/string()" }
    XmlRole { name: "woeid"; query: "@woeid/string()" }
    XmlRole { name: "geo_is_family"; query: "@geo_is_family/string()" }
    XmlRole { name: "geo_is_friend"; query: "@geo_is_friend/string()" }
    XmlRole { name: "geo_is_contact"; query: "@geo_is_contact/string()" }
    XmlRole { name: "geo_is_public"; query: "@geo_is_public/string()" }
}
