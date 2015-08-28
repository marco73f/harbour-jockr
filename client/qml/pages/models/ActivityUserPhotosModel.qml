import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import harbour.jockr 1.0

XmlListModel {
    property string api: "flickr.activity.userPhotos"
    property string params: "timeframe:30d:per_page:" + GValue.per_page + ":item:type,id,owner,ownername,comments,secret,server,farm,views,faves,activity/event:event:type,username"
    property string strStatus

//    function getQueryString() {
//        //return "timeframe:30d:per_page:" + GValue.per_page + ":item:type,id,owner,ownername,comments,secret,server,farm,views,faves,activity/event:title::activity::event:type,username"
//        return "timeframe:30d:per_page:" + GValue.per_page + ":item:type,id,owner,ownername,comments,secret,server,farm,views,faves,activity/event:event:type,username"
//    }

//    Component.onCompleted: {
//        loadData()
//    }

//    function loadData() {
//        Requestor.queryApi("method:" + api + ":" + params)
//    }

    query: "/rsp/items/item"

    XmlRole { name: "title"; query: "title/string()" }
    XmlRole { name: "type"; query: "@type/string()" }
    XmlRole { name: "id"; query: "@id/string()" }
    XmlRole { name: "owner"; query: "@owner/string()" }
    XmlRole { name: "ownername"; query: "@ownername/string()" }
    XmlRole { name: "secret"; query: "@secret/string()" }
    XmlRole { name: "server"; query: "@server/string()" }
    XmlRole { name: "farm"; query: "@farm/string()" }
    XmlRole { name: "comments"; query: "@comments/string()" }
    XmlRole { name: "faves"; query: "@faves/string()" }
    XmlRole { name: "views"; query: "@views/string()" }
    XmlRole { name: "notes"; query: "@notes/string()" }
    //XmlRole { name: "comments_"; query: "activity/event/string()" }
    XmlRole { name: "eventtype"; query: "activity/event/@type/string()" }

}
