import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import harbour.jockr 1.0

XmlListModel {
    property string api: "flickr.photosets.delete"
    property string params: "photoset_id:"
    property string strStatus
    property bool loading: false

    //query: "/rsp/photos/photo"
}
