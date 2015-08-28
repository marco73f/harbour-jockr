import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import harbour.jockr 1.0

XmlListModel {
    property string api: "flickr.photos.getInfo"
    property string params
    property string strStatus

    query: "/rsp/photo"

    XmlRole { name: "id";               query: "@id/string()" }
    XmlRole { name: "secret";           query: "@secret/string()" }
    XmlRole { name: "server";           query: "@server/string()" }
    XmlRole { name: "farm";             query: "@farm/string()" }
    XmlRole { name: "dateuploaded";     query: "@dateuploaded/number()" }
    XmlRole { name: "isfavorite";       query: "@isfavorite/number()" }
    XmlRole { name: "license";          query: "@license/number()" }
    XmlRole { name: "safety_level";     query: "@safety_level/number()" }
    XmlRole { name: "rotation";         query: "@rotation/number()" }
    XmlRole { name: "originalsecret";   query: "@originalsecret/string()" }
    XmlRole { name: "originalformat";   query: "@originalformat/string()" }
    XmlRole { name: "views";            query: "@views/number()" }
    XmlRole { name: "media";            query: "@media/string()" }

    XmlRole { name: "ownerNsid";        query: "owner/@nsid/string()" }
    XmlRole { name: "ownerUsername";    query: "owner/@username/string()" }
    XmlRole { name: "ownerRealname";    query: "owner/@realname/string()" }
    XmlRole { name: "ownerLocation";    query: "owner/@location/string()" }
    XmlRole { name: "ownerIconserver";  query: "owner/@iconserver/string()" }
    XmlRole { name: "ownerIconfarm";    query: "owner/@iconfarm/string()" }
    XmlRole { name: "ownerPath_alias";  query: "owner/@path_alias/string()" }

    XmlRole { name: "title";            query: "title/string()" }
    XmlRole { name: "description";      query: "description/string()" }

    XmlRole { name: "ispublic";         query: "visibility/@ispublic/number()" }
    XmlRole { name: "isfriend";         query: "visibility/@isfriend/number()" }
    XmlRole { name: "isfamily";         query: "visibility/@isfamily/number()" }

    XmlRole { name: "datePosted";       query: "dates/@posted/number()" }
    XmlRole { name: "dateTaken";        query: "dates/@taken/string()" }
    XmlRole { name: "dateTakengranularity"; query: "dates/@takengranularity/number()" }
    XmlRole { name: "lastupdate";       query: "dates/@lastupdate/number()" }

    XmlRole { name: "permcomment";      query: "permissions/@permcomment/number()" }
    XmlRole { name: "permaddmeta";      query: "permissions/@permaddmeta/number()" }
    XmlRole { name: "cancomment";       query: "editability/@cancomment/number()" }
    XmlRole { name: "canaddmeta";       query: "editability/@canaddmeta/number()" }
    XmlRole { name: "publicCancomment"; query: "publiceditability/@cancomment/number()" }
    XmlRole { name: "publicCanaddmeta"; query: "publiceditability/@canaddmeta/number()" }
    XmlRole { name: "candownload";      query: "usage/@candownload/number()" }
    XmlRole { name: "canblog";          query: "usage/@canblog/number()" }
    XmlRole { name: "canshare";         query: "usage/@canshare/number()" }

    XmlRole { name: "comments";         query: "comments/number()" }
    XmlRole { name: "notes";            query: "notes/string()" }
    XmlRole { name: "haspeople";         query: "people/@haspeople/number()" }
}

