import QtQuick 2.0

import request_manager 1.0

Rectangle {
    id: root

    readonly property string genIntColor:   "#4242aa"

    property string photo: ""
    property string name: ""
    property string lastName: ""
    property string email: ""
    property string number: ""

    property string title: ""
    property string description: ""
    property real latitude: 0
    property real longitude: 0
    property int date: 0
    property bool starred: false

    width: 400
    height: 250
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
            right: favorite.left
            topMargin: 10
            leftMargin: 10
            rightMargin: 15
        }

        font.pixelSize: 17
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Image {
        id: favorite

        source: root.starred ? "qrc:/resources/icons/starFilled.png" : "qrc:/resources/icons/star.png"
        width: 30
        height: 30
        anchors {
            top: parent.top
            right: parent.right
            rightMargin: 10
            topMargin: 10
        }
    }
    MouseArea {
        id: favoriteMouse
        anchors.fill: favorite
        z: 1000
        onClicked: {
            root.starred = !root.starred
            RequestManager.addToFavorites(root.longitude, root.latitude, root.title, root.description, root.date)
        }
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

    MouseArea {
        id: mouse2
        anchors.fill: parent
        z: 1
        hoverEnabled: true
        onEntered: {/*mainWindow.showShortRequestInfo(marker.coordinate);*/ root.visible = true}
        onExited: {root.visible = false}
    }
}
