import QtQuick 2.0

Item{
    id: flickrText

    property alias text: body.text
    property alias elide: body.elide
    property alias textFormat: body.textFormat
    property alias wrapMode: body.wrapMode
    property color headerColor: "lightblue"
    property string header

    height:  body.paintedHeight
    width:  header.paintedWidth+10+body.paintedWidth
    Row{
        spacing: 10
        anchors.fill: parent

        Text {
            id: header
            color:  headerColor
            font.bold: true
            text:  flickrText.header + ":"
            visible: flickrText.header != ""
        }

        Text {
            id: body
            color: "black"
            smooth:  true
            width: flickrText.width - header.paintedWidth
            font.bold: true
        }
    }
}
