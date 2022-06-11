import QtQuick 2.15
import QtQuick.Window 2.15

import QtLocation 5.15 // Map
import QtQuick.Controls 2.3
import QtPositioning 5.15

import "resources/Constants"
import request_manager 1.0
import session_manager 1.0
import request_model 1.0
import request 1.0

ApplicationWindow {
    id: mainWindow

    visibility: "FullScreen"
    visible: true

    property string title: "Some title"
    property string description: "Some description"
    property double latitude: 0
    property double longitude: 0
    property int date: 0

    readonly property string genIntColor:   "#4242aa"
    readonly property string userName:      SessionManager.name
    readonly property string userNumber:    SessionManager.phone
    readonly property string fontColor:     "white"

    Map {
        id: map
        property bool isGetLocation: false
        visible: true
        anchors.fill: parent
        plugin: googleMaps
        center: QtPositioning.coordinate(49.841598, 24.028394)
        zoomLevel: 13

        property var marker: null
        property var coor: null

        function createMarker(latitude, longitude, title, description, date) {
            var circle = Qt.createQmlObject('
import QtQuick 2.0
import QtLocation 5.15

MapQuickItem {
    id: root
    anchorPoint.x: image.width / 2
    anchorPoint.y: image.height
    width: image.width
    height: image.height

    coordinate {
        latitude: root.latitude
        longitude: root.longitude
    }

    property alias title: reqWin.title
    property alias description: reqWin.description
    property alias latitude: reqWin.latitude
    property alias longitude: reqWin.longitude
    property alias date: reqWin.date

    sourceItem: Item {
        Image {
            id: image
            source: "qrc:/resources/icons/marker.png"
            MouseArea {
                id:mouse
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {reqWin.visible = true}
                onExited: {reqWin.visible = false}
            }
        }

        ShortRequest {
            id: reqWin

            visible: false

            anchors {
                bottom: image.top
                horizontalCenter: image.horizontalCenter
            }
        }
    }
}', map)
            circle.latitude = latitude
            circle.longitude = longitude
            circle.title = title
            circle.description = description
            circle.date = date
            map.marker = circle
            map.addMapItem(circle)
        }

        MouseArea {
            anchors.fill: parent
            onDoubleClicked: {
                if (map.isGetLocation) {
                    map.removeMapItem(map.marker)
                    map.createMarker(map.toCoordinate(Qt.point(mouse.x,mouse.y)))
                    map.coor = map.toCoordinate(Qt.point(mouse.x,mouse.y))
                }
            }

            VButton {
                id: sendLocationBtn

                visible: map.isGetLocation

                width: 300
                height: 50

                text: map.marker === null ? qsTr("Double click to choose location") : qsTr("Choose this location")

                anchors.bottomMargin: 20
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter

                onClicked: {
                    if (map.marker !== null) {
                        addRequestPopup.addRequest(map.coor.latitude, map.coor.longitude)
                        addRequestPopup.clear()
                        map.isGetLocation = false;
                        map.removeMapItem(map.marker)
                    }
                }
            }
        }
    }

    Plugin {
        id: googleMaps
        name: "mapboxgl" // "mapboxgl", "esri", ...
    }

    IconButton {
        id: menuButton
        anchors {
            top: parent.top
            left: parent.left
            leftMargin: 10
            topMargin: 10
        }
        width: 50
        height: 50
        icon.source: "qrc:/resources/icons/menu.png"
        onClicked: { // TODO: Animation onValueChanged
            menu.open()
        }
    }

    IconButton {
        id: quit
        anchors {
            top: parent.top
            right: parent.right
        }

        uri: "qrc:/resources/icons/exitButton.png"
        width: 60 // TODO: size
        height: 60
        z: 1000

        onClicked:{
            mainWindow.close()
        }
    }

    IconButton {
        id: add
        anchors {
            bottom: parent.bottom
            right: parent.right
            rightMargin: 10
            bottomMargin: 10
        }

        uri: "qrc:/resources/icons/add.png"
        width: 80 // TODO: size
        height: 80

        onClicked:{
            addRequestPopup.open()
        }
    }

    Popup {
        id: menu

        modal: true
        width: requestsListRect.width + menuVertDel.width + menuRectangle.width
        height: mainWindow.height

        Overlay.modal: Rectangle {
            color: "#bb101010"
        }

        contentItem: Item {
            id: menuItem

            width: parent.width
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }

            Rectangle {
                id: menuRectangle

                color: mainWindow.genIntColor
                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                }

                width: 350

                Item {
                    id: topPanel

                    property int panelLeftMargin: 20

                    height: 230

                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                    }

                    UserPhoto {
                        id: userMenuPhoto

                        anchors {
                            top: parent.top
                            left: parent.left
                            topMargin: topPanel.panelLeftMargin
                            leftMargin: topPanel.panelLeftMargin
                        }
                    }

                    Text {
                        id: menuUserName

                        text: mainWindow.userName
                        color: mainWindow.fontColor

                        anchors {
                            top: userMenuPhoto.bottom
                            left: parent.left
                            topMargin: 20
                            leftMargin: topPanel.panelLeftMargin
                        }
                    }

                    Text {
                        id: menuUserNumber

                        text: mainWindow.userNumber
                        color: mainWindow.fontColor

                        anchors {
                            top: menuUserName.bottom
                            left: parent.left
                            topMargin: 20
                            leftMargin: topPanel.panelLeftMargin
                        }
                    }
                }

                DelimiterLine {
                    id: panelDel
                    anchors {
                        left: parent.left
                        right: parent.right
                        top: topPanel.bottom
                    }
                }

                Item {
                id: bottomPanel

                property int btnHeight: 50

                anchors {
                    top: panelDel.bottom
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                    topMargin: 5
                }

                PanelButton {
                    id: usersRequestsBtn

                    btnText: qsTr("My Requests")
                    height: bottomPanel.btnHeight

                    anchors {
                        left: parent.left
                        right: parent.right
                        top: parent.top
                    }

                    onClicked: {
                        RequestManager.getUsersRequests()
                        requestsListRect.open()
                    }
                }

                PanelButton {
                    id: lastBtn

                    btnText: qsTr("Recently viewed")
                    height: bottomPanel.btnHeight

                    anchors {
                        left: parent.left
                        right: parent.right
                        top: usersRequestsBtn.bottom
                    }

                    onClicked: {
                        RequestManager.getLastViewedList()
                        requestsListRect.open()
                    }
                }

                PanelButton {
                    id: favoritesBtn

                    btnText: qsTr("Favorites")
                    height: bottomPanel.btnHeight

                    anchors {
                        left: parent.left
                        right: parent.right
                        top: lastBtn.bottom
                    }

                    onClicked: {
                        RequestManager.getFavoritesList();
                        requestsListRect.open()
                    }
                }

                PanelButton {
                    id: settingsBtn

                    btnText: qsTr("Settings")
                    height: bottomPanel.btnHeight

                    anchors {
                        left: parent.left
                        right: parent.right
                        top: favoritesBtn.bottom
                    }

                    onClicked: {
                        menu.close()
                        settingsWindow.open()
                    }
                }
            }
            }

            DelimiterLine {
                id: menuVertDel

                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: menuRectangle.right
                }
                width: 0
            }

            Rectangle {
                id: requestsListRect
                property int openedWidth: 640
                width: 0
                anchors {
                    left: menuVertDel.right
                    top: parent.top
                    bottom: parent.bottom
                }

                color: mainWindow.genIntColor

                function open() {
                    width = requestsListRect.openedWidth
                    menuVertDel.width = 2
                }

                function close() {
                    width = 0
                    menuVertDel.width = 0
                }

                function opened() {
                    return width == requestsListRect.openedWidth
                }
            }

            ListView {
                id: requestsView
                property int textHeight: 20
                anchors.fill: requestsListRect
                visible: requestsListRect.opened()

                model: reqModel
//                spacing: 5
//                clip: true
//                headerPositioning: ListView.OverlayHeader
                delegate: Rectangle {
                    id: reqBackground

                    anchors {
                        left: parent.left
                        right: parent.right
                    }

                    height: 100
                    color: "pink"

                    UserPhoto {
                        id: reqPhoto
                        size: parent.height - 10
                        uri: model.photo
                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                            leftMargin: 5
                        }

                    }

                    Text {
                        id: reqTitle

                        text: model.title
                        wrapMode: Text.Wrap
//                        height: requestsView.textHeight
                        anchors {
                            left: reqPhoto.right
                            right: parent.right
                            top: parent.top
                        }
                    }

                    Text {
                        id: reqDesc
                        text: model.description
                        wrapMode: Text.Wrap
//                        height: requestsView.textHeight
                        anchors {
                            left: reqPhoto.right
                            right: parent.right
                            top: reqTitle.bottom
                            bottom: parent.bottom
                        }
                    }
                }
            }

            RequestModel {
                id: reqModel
            }
        }

        onClosed: {
            requestsListRect.close()
        }
    }

    SettingsPopup {
        id: settingsWindow

        width: 400
        height: 600
        anchors.centerIn: parent
    }

    AddRequestPopup {
        id: addRequestPopup
        anchors.centerIn: parent
        onGetLocation: {
            map.isGetLocation = true
        }
    }

    Popup {
        id: signInPopup
        anchors.centerIn: parent
        modal: true
        closePolicy: Popup.NoAutoClose
        background: null
        width: 500
        height: 400
        Overlay.modal: Rectangle {
            color: "#bb101010"
        }
        contentItem: SignInWindow {
            onClose: {
                signInPopup.close()
                createAccPopup.open()
            }
        }
    }

    Popup {
        id: createAccPopup
        anchors.centerIn: parent
        modal: true
        closePolicy: Popup.CloseOnPressOutside
        background: null
        width: 600
        height: 500
        Overlay.modal: Rectangle {
            color: "#bb101010"
        }
        contentItem: CreateAccWin {
            onCreated: {
                createAccPopup.close()
            }
            onBack: {
                createAccPopup.close()
                signInPopup.open()
            }
        }
    }

    Component.onCompleted: {
        signInPopup.open()

        map.clearMapItems()
        var list = RequestManager.getRequests();
        for(var it = 0; it < list.length; it++)
        {
            map.createMarker(list[it].latitude, list[it].longitude, list[it].title, list[it].description, list[it].date)
        }

    }

      Connections {
          target: SessionManager
          onSignedInChanged: {
              if (SessionManager.signedIn) {
                  signInPopup.close()
              } else {
                  signInPopup.open()
              }
          }
      }
}
