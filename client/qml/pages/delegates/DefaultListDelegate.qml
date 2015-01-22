import QtQuick 2.0
    Component {
    Item {
        id: wrapper; width: wrapper.ListView.view.width; height: 86
        Item {
            id: moveMe
            Rectangle { color: "black"; opacity: index % 2 ? 0.2 : 0.4; height: 84; width: wrapper.width; y: 1 }
            Rectangle {
                x: 6; y: 4; width: 76; height: 76; color: "white"; smooth: true

                Image {
                    source: "https://farm" + farm + ".staticflickr.com/" + server + "/" + id + "_" + secret + "_m.jpg"
                    width: parent.width; height: parent.height
                    x: 0; y: 0 }
            }
            Column {
                x: 92; width: wrapper.ListView.view.width - 95; y: 15; spacing: 2
                Text { text: title; color: "white"; width: parent.width; font.bold: true; elide: Text.ElideRight; style: Text.Raised; styleColor: "black" }
                Text { text: datetaken; width: parent.width; elide: Text.ElideRight; color: "#cccccc"; style: Text.Raised; styleColor: "black" }
            }
        }
    }
}
