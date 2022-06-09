import QtQuick 2.0
import QtLocation 5.15

MapQuickItem {
    id: marker
    anchorPoint.x: image.width/4
    anchorPoint.y: image.height

    sourceItem: Image {
        id: image
        source: "qrc:/resources/icons/add.png"
//        source: "qrc:/recources/icons/marker.png"
    }
}
