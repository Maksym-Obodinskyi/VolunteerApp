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

    readonly property string genIntColor:   "#00897b"
    readonly property string userName:      SessionManager.name
    readonly property string userLastName:  SessionManager.lastName
    readonly property string userNumber:    SessionManager.phone
    readonly property string pressedColor:  "#00796b"
    readonly property string hoveredColor:  "#009688"
    readonly property string defColor:      mainWindow.genIntColor
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

        function createMarker(latitude, longitude, title, description, date, name, lastName, email, phone) {
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
    property alias name: reqWin.name
    property alias lastName: reqWin.lastName
    property alias email: reqWin.email
    property alias phone: reqWin.phone

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
            genIntColor: mainWindow.genIntColor

            anchors {
                bottom: image.top
                horizontalCenter: image.horizontalCenter
            }
            onOpenLongReq: {
                longReq.open(title, description, name, lastName, email, phone)
            }
        }
    }
}', map)
            circle.latitude = latitude
            circle.longitude = longitude
            circle.title = title
            circle.description = description
            circle.date = date
            circle.name = name
            circle.lastName = lastName
            circle.email = email
            circle.phone = phone
            map.marker = circle
            map.addMapItem(circle)
        }

        function createEmptyMarker(latitude, longitude) {
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

    property alias latitude: root.coordinate.latitude
    property alias longitude: root.coordinate.longitude

    sourceItem: Item {
        Image {
            id: image
            source: "qrc:/resources/icons/marker.png"
        }
    }
}', map)
            circle.latitude = latitude
            circle.longitude = longitude
            map.coor = circle.coordinate
            map.marker = circle
            map.addMapItem(circle)
        }

        MouseArea {
            anchors.fill: parent
            onDoubleClicked: {
                if (map.isGetLocation) {
                    map.removeMapItem(map.marker)
                    map.coor = map.toCoordinate(Qt.point(mouse.x,mouse.y))
                    map.createEmptyMarker(map.coor.latitude, map.coor.longitude)
                }
            }

            Item {
                id: chooseLocationControls

                width: 620
                height: 60

                property int btnWidth: width / 2 - 20
                property int btnHeight: height

                anchors {
                    bottom: parent.bottom
                    bottomMargin: 20
                    horizontalCenter: parent.horizontalCenter
                }

                VButton {
                    id: sendLocationBtn

                    visible: map.isGetLocation

                    width: chooseLocationControls.btnWidth
                    height: chooseLocationControls.btnHeight

                    text: map.marker === null ? qsTr("Double click to choose location") : qsTr("Choose this location")

                    textColor: "white"
                    font.pixelSize: 20
                    pressedColor: mainWindow.pressedColor
                    hoveredColor: mainWindow.hoveredColor
                    defColor: mainWindow.defColor

                    anchors {
                        bottom: parent.bottom
                        right: parent.right
                    }

                    onClicked: {
                        if (map.marker !== null) {
                            addRequestPopup.addRequest(map.coor.latitude, map.coor.longitude)
                            addRequestPopup.clear()
                            map.isGetLocation = false;
                            map.clearMapItems()
                        }
                    }

                    onVisibleChanged: {
                        if (visible) {
                            map.marker = null
                            map.coor = null
                            map.clearMapItems();
                        }
                    }
                }

                VButton {
                    id: cancelLocationBtn
                    width: chooseLocationControls.btnWidth
                    visible: map.isGetLocation
                    height: chooseLocationControls.btnHeight
                    text: qsTr("Cancel")
                    textColor: "white"
                    font.pixelSize: 20
                    pressedColor: mainWindow.pressedColor
                    hoveredColor: mainWindow.hoveredColor
                    defColor: mainWindow.defColor
                    anchors {
                        left: parent.left
                        bottom: parent.bottom
                    }

                    onClicked: {
                        map.clearMapItems()
                        map.isGetLocation = false
                        RequestManager.getRequests()
                    }
                }
            }

        }
    }

    LongRequest {
        id: longReq

        visible: false

        genIntColor: mainWindow.genIntColor

        function open(title, description, name, lastName, email, phone) {
            longReq.title = title
            longReq.description = description
            longReq.name = name
            longReq.lastName = lastName
            longReq.email = email
            longReq.phone = phone
            longReq.visible = true
        }

        function close() {
            longReq.visible = false
        }

        anchors.centerIn: parent

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

                    VText {
                        id: menuUserName

                        text: mainWindow.userName + " " + mainWindow.userLastName

                        anchors {
                            top: userMenuPhoto.bottom
                            left: parent.left
                            topMargin: 20
                            leftMargin: topPanel.panelLeftMargin
                        }
                    }

                    VText {
                        id: menuUserNumber

                        text: mainWindow.userNumber

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

                    text: qsTr("My Requests")
                    height: bottomPanel.btnHeight

                    genIntColor: mainWindow.genIntColor

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

                    text: qsTr("Recently viewed")
                    height: bottomPanel.btnHeight

                    enabled: false

                    genIntColor: mainWindow.genIntColor

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

                    text: qsTr("Favorites")
                    height: bottomPanel.btnHeight

                    genIntColor: mainWindow.genIntColor

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

                    text: qsTr("Settings")
                    height: bottomPanel.btnHeight

                    genIntColor: mainWindow.genIntColor

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
                property int openedWidth: 440
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
                delegate: Rectangle {
                    id: reqBackground

                    anchors {
                        left: parent.left
                        right: parent.right
                    }

                    height: 100
                    color: reqMenuItem.pressed ? "#00796b" : reqMenuItem.containsMouse ? "#009688" : genIntColor

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

                    VText {
                        id: reqTitle

                        text: model.title
                        wrapMode: Text.Wrap
                        horizontalAlignment: Text.AlignHCenter
                        anchors {
                            top: parent.top
                            left: reqPhoto.right
                            right: parent.right
                            topMargin: 5
                        }
                    }

                    VText {
                        id: reqDesc
                        text: model.description
                        wrapMode: Text.Wrap
                        font.pixelSize: 16
                        horizontalAlignment: Text.AlignHCenter
                        clip: true
                        elide: Text.ElideRight
                        anchors {
                            top: reqTitle.bottom
                            left: reqPhoto.right
                            right: parent.right
                            bottom: parent.bottom
                            topMargin: 5
                        }
                    }

                    MouseArea {
                        id: reqMenuItem
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            console.log("open")
                            longReq.open(  model.title
                                         , model.description
                                         , model.name
                                         , model.lastName
                                         , model.email
                                         , model.number)
                            menu.close()
                        }
                    }

//                    DelimiterLine {
//                        height: 2
//                        anchors {
//                            left: parent.left
//                            right: parent.right
//                            bottom: parent.bottom
//                        }
//                    }
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
        onEditAcc: {
            createAcc.edit = true
            createAccPopup.open()
            settingsWindow.close()
        }
    }

    AddRequestPopup {
        id: addRequestPopup
        anchors.centerIn: parent
        genIntColor: mainWindow.genIntColor
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
            id: signIn
            failedToSignIn: false
            genIntColor: mainWindow.genIntColor
            onCreateAccount: {
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
        Overlay.modal: Rectangle {
            color: "#bb101010"
        }

        width: 600
        height: createAcc.edit ? 520 : 460
        contentItem: CreateAccWin {
            id: createAcc
            failedToCreate: false
            genIntColor: mainWindow.genIntColor
            onBack: {
                createAccPopup.close()
                signInPopup.open()
            }
        }
    }

    Component.onCompleted: {
        signInPopup.open()

        map.clearMapItems()
    }

    Connections {
        target: SessionManager
        function onSignedInChanged() {
            if (SessionManager.signedIn) {
                signInPopup.close()
                signIn.failedToSignIn = false
            } else {
                signIn.failedToSignIn = true
                signInPopup.open()
            }
        }

        function onAccountCreatedChanged() {
            if (SessionManager.accountCreated) {
                createAccPopup.close()
                signIn.failedToSignIn = false
            } else {
                createAccPopup.open()
                signIn.failedToSignIn = true
            }
        }

        function onUpdateRequests() {
            var list = SessionManager.data
            for (var it = 0; it < list.length; it++) {
                map.createMarker(list[it].latitude
                                 , list[it].longitude
                                 , list[it].title
                                 , list[it].description
                                 , list[it].date
                                 , list[it].name
                                 , list[it].lastName
                                 , list[it].email
                                 , list[it].phone)
            }
        }
    }
}
