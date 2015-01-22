import QtQuick 2.1

Item{
    id: loading
    width: image.width
    height:  image.height
    Image {
        id: image
        anchors.centerIn: parent
        source: "qrc:/qml/pages/images/loading-1.png"
        NumberAnimation on rotation {
            from: 0; to: 360; running: loading.visible == true; loops: Animation.Infinite; duration: 900
        }

        smooth: true
    }
    Image{
        anchors.centerIn: parent
        source: "qrc:/qml/pages/images/loading-2.png"
        NumberAnimation on rotation {
            from: 360; to: 0; running: loading.visible == true; loops: Animation.Infinite; duration: 900
        }
        smooth: true
    }

    Image {
        anchors.centerIn: parent
        source: "qrc:/qml/pages/images/loading-3.png"
        NumberAnimation on rotation {
            from: 0; to: 360; running: loading.visible == true; loops: Animation.Infinite; duration: 1800
        }

        smooth: true
    }
    Image{
        anchors.centerIn: parent
        source: "qrc:/qml/pages/images/loading-4.png"
        NumberAnimation on rotation {
            from: 360; to: 0; running: loading.visible == true; loops: Animation.Infinite; duration: 1800
        }
        smooth: true
    }
}
