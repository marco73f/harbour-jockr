import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import harbour.jockr 1.0

XmlListModel {
    property string api: "flickr.photosets.addPhoto"
    property string params: "photoset_id:"
    property string photo_id: ":photo_id:" //Obbligatorio, The id of the photo to add to the set.
    property string strStatus
    property bool loading: false

    //query: "/rsp/photos/photo"
}
