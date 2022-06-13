import QtQuick 2.0
import QtGraphicalEffects 1.15
import "resources/Constants"

Rectangle {
    id: root
    readonly property string genPhotoColor: "#ffffff"
    property int size: 90
    property string uri: "qrc:/resources/icons/defaultUser.png"
    readonly property string defaultSource: "qrc:/resources/icons/defaultUser.png"
    clip: true



    Item {
        anchors.fill: root
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: root
        }
        Image {
            id: image
    //        anchors.centerIn: parent
            clip: true
            anchors.fill: parent
            source: uri
            onStatusChanged: {
                if ( (image.status == Image.Error) && source !== root.defaultSource ) {
                    source = defaultSource
                }
            }
        }
    }

    width: size
    height: size
    radius: size / 2
    color: root.genPhotoColor
}
