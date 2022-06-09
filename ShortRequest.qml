import QtQuick 2.0

Rectangle {
    id: root

    property string photo: ""

    width: 200
    height: 150
    radius: 10

    UserPhoto {
        id: photo

        anchors {
            top: parent.top
            left: parent.left
            topMargin: 10
            leftMargin: 10
        }
    }

    Text {
        id: title
        anchors {
            top : parent.top
            left: photo.left
            topMargin: 10
            leftMargin: 10
        }

        font.pixelSize: 15
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
