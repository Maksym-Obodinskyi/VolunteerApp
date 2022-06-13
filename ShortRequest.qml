import QtQuick 2.0

import request_manager 1.0

Rectangle {
    id: root

    property alias genIntColor: root.color

    property string photo: ""
    property string name: ""
    property string lastName: ""
    property string email: ""
    property string phone: ""

    property string title: ""
    property string description: ""
    property real latitude: 0
    property real longitude: 0
    property int date: 0
    property bool starred: false

    signal openLongReq

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

    VText {
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

        font.pixelSize: 18
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Image {
        id: favorite

        source: root.starred ? "qrc:/resources/icons/yellowStar.png" : "qrc:/resources/icons/whiteStar.png"
        width: 40
        height: 40
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
            RequestManager.addToFavorites(root.name
                                          , root.lastName
                                          , root.email
                                          , root.phone
                                          , root.photo
                                          , root.latitude
                                          , root.longitude
                                          , root.title
                                          , root.description
                                          , root.date)
        }
    }

    VText {
        id: descT

        text: root.description
        anchors {
            top : photoT.bottom
            left: parent.left
            right: parent.right
            topMargin: 10
            leftMargin: 10
        }

        font.pixelSize: 16
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
        id: mouse2
        anchors.fill: parent
        z: 1
        hoverEnabled: true
        onEntered: {root.visible = true}
        onExited: {root.visible = false}
        onClicked: {
            root.openLongReq()
        }
    }
}
