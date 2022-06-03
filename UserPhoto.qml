import QtQuick 2.0

import "resources/Constants"

Rectangle {
    id: root
    readonly property string genPhotoColor: "#ffffff"
    property int size: 90
    property string uri: ""

    Text {
        anchors.centerIn: parent
        text: uri
    }

    width: size
    height: size
    radius: size / 2
    color: root.genPhotoColor
}
