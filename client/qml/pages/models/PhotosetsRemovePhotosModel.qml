import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import harbour.jockr 1.0

XmlListModel {
    property string api: "flickr.photosets.removePhotos"
    property string params: "photoset_id:"
    property string photo_ids: ":photo_ids:" //Obbligatorio, Comma-delimited list of photo ids to remove from the photoset.
    property string strStatus
    property bool loading: false

    //query: "/rsp/photos/photo"
}
