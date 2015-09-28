import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import harbour.jockr 1.0

XmlListModel {
    property string api: "flickr.photosets.create"
    property string params: ""
    property string title: "title:" //Obbligatorio, A title for the photoset.
    property string description: ":description:"
    property string primary_photo_id: ":primary_photo_id:" //Obbligatorio, The id of the photo to represent this set. The photo must belong to the calling user.
    property string strStatus
    property bool loading: false

    query: "/rsp/photoset"

    XmlRole { name: "pid"; query: "@id/string()" }
    XmlRole { name: "purl"; query: "@url/string()" }
}
