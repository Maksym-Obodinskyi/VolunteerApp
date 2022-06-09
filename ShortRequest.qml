import QtQuick 2.0

Rectangle {
    id: root

    readonly property string genIntColor:   "#4242aa"

    property string photo: ""
    property string title: ""
    property string description: ""

    width: 300
    height: 200
    radius: 10
    color: root.genIntColor

    UserPhoto {
        id: photoT

        uri: root.photo

        anchors {
            top: parent.top
            left: parent.left
            topMargin: 10
            leftMargin: 10
        }
    }

    Text {
        id: titleT

        height: contentHeight

        text: root.title

        anchors {
            top : parent.top
            left: photoT.right
            right: parent.right
            topMargin: 10
            leftMargin: 10
            rightMargin: 15
        }

        font.pixelSize: 15
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Text {
        id: descT

        text: root.description
        anchors {
            top : photoT.bottom
            left: parent.left
            right: parent.right
            topMargin: 10
            leftMargin: 10
        }

        font.pixelSize: 15
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
