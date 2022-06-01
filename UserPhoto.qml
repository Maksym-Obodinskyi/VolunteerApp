import QtQuick 2.0

import "resources/Constants"

Rectangle {
    id: root
    readonly property string genPhotoColor: "#ffffff"

    width: 90
    height: 90
    radius: width/2
    color: root.genPhotoColor
}
