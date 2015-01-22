import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import Jockr 1.0

XmlListModel {
    property string api: "flickr.favorites.remove"
    property string params: "id:"
    property string strStatus

    //query: "/rsp/photos/photo"
}
