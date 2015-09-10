import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import harbour.jockr 1.0

XmlListModel {
    property string api: "flickr.people.getPublicPhotos"
    property string nsid
    property string strStatus
    property bool loading: false

//    function getQueryString(nsid) {
//        return "user_id:" + nsid
//    }

    Component.onCompleted: {
        console.log("PeopleGetInfoModel.onCompleted nsid = " + nsid)
        if (nsid !== "") {
            console.log("nsid !== ")
            loadData()
        }
        else {
            console.log("nsid == ")
            xml = ""
        }
    }

    function loadData() {
        console.log("loadData - method:" + api + ":user_id:" + nsid)
        Requestor.queryApi("method:" + api + ":user_id:" + nsid)
    }

    query: "/rsp/person"

    XmlRole { name: "nsid";         query: "@nsid/string()" }
    XmlRole { name: "ispro";        query: "@ispro/number()" }
    XmlRole { name: "iconserver";   query: "@iconserver/string()" }
    XmlRole { name: "iconfarm";     query: "@iconfarm/string()" }
    XmlRole { name: "realname";     query: "realname/string()" }
    XmlRole { name: "username";     query: "username/string()" }
    XmlRole { name: "geolocation";  query: "location/string()" } // Property name can't be location. It prints the object location in memory
    XmlRole { name: "firstdatetaken"; query: "photos/firstdatetaken/string()" }
    XmlRole { name: "count";        query: "photos/count/string()" }

    onStatusChanged: {
        if (status === XmlListModel.Ready) { strStatus = count + " Items loaded" }
        if (status === XmlListModel.Loading) { strStatus = "Loading" }
        if (status === XmlListModel.Error) { strStatus = "Error:\n" + errorString }
        if (status === XmlListModel.Null) { strStatus = "Loading" }
    }
}
