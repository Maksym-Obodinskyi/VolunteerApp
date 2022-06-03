import QtQuick 2.15
import QtQuick.Window 2.15

import QtLocation 5.15 // Map
import QtQuick.Controls 2.3
import QtPositioning 5.15

import "resources/Constants"
import request_manager 1.0
import request_model 1.0

ApplicationWindow {
    id: mainWindow

    visibility: "FullScreen"
    visible: true

    readonly property string genIntColor:   "#0047b3"
    readonly property string userName:      "Maksym"
    readonly property string userNumber:    "+380930975704"

    Map {
        id: map
        anchors.fill: parent
        plugin: googleMaps
        center: QtPositioning.coordinate(49.841598, 24.028394)
        zoomLevel: 13
        z:0
    }

    Plugin {
        id: googleMaps
        name: "mapboxgl" // "mapboxgl", "esri", ...
        // specify plugin parameters if necessary
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
            addRequest.open()
        }
    }

    Popup {
        id: menu

        modal: true
        width: requestsListRect.width + menuVertDel.width + menuRectangle.width
        height: mainWindow.height

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

    Popup {
        id: settingsWindow

        property int genLeftMargin: 20

        visible: false

        width: 400
        height: 600
        anchors.centerIn: parent
        modal: true

        function open() {
            visible = true
        }

        contentItem: Rectangle {
            id: settingsRectangle
            anchors.fill: parent
            color: mainWindow.genIntColor

            Item {
                id: settingsHeader

                property int iconsSize: 40

                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }

                height: 150

                Text {
                    id: settingsTextHeader
                    text: qsTr("Settings")
                    height: 40
                    font.pixelSize: 20
                    anchors {
                        left: parent.left
                        right: parent.right
                        top: parent.top
                        topMargin: 10
                        leftMargin: 20
                    }
                }

                UserPhoto {
                    id: settingsUserPhoto
                    anchors {
                        top: settingsTextHeader.bottom
                        left: parent.left
                        leftMargin: 20
                    }
                }

                Text {
                    id: settingsUserName
                    text: mainWindow.userName
                    anchors {
                        top: settingsTextHeader.bottom
                        left: settingsUserPhoto.right
                        leftMargin: settingsWindow.genLeftMargin
                    }


                }

                Text {
                    id: settingsUserNumber
                    text: mainWindow.userNumber
                    anchors {
                        left: settingsUserPhoto.right
                        top: settingsUserName.bottom
                        leftMargin: settingsWindow.genLeftMargin
                        topMargin: 10
                    }
                }

                IconButton {
                    id: showMore

                    anchors {
                        top: parent.top
                        right: settingsQuit.left
                        rightMargin: 10
                    }
                    height: settingsHeader.iconsSize
                    width: settingsHeader.iconsSize

                    uri: "qrc:/resources/icons/showMore.png"
                }

                IconButton {
                    id: settingsQuit

                    anchors {
                        top: parent.top
                        right: parent.right
                    }
                    height: settingsHeader.iconsSize
                    width: settingsHeader.iconsSize

                    uri: "qrc:/resources/icons/exitButton.png"
                    onClicked: {
                        settingsWindow.close()
                    }
                }
            }

            DelimiterLine {
                id: settingsDel
                anchors {
                    left: parent.left
                    right: parent.right
                    top: settingsHeader.bottom
                }
            }

            Item {
                id: settingsFilling

                property int btnHeight: 40

                anchors {
                    left: parent.left
                    right: parent.right
                    top: settingsDel.bottom
                    bottom: parent.bottom
                    topMargin: 5
                }

                PanelButton {
                    id: editProfText
                    anchors {
                        left: parent.left
                        right: parent.right
                        top: parent.top
                    }
                    text: qsTr("editProfile")
                    height: settingsFilling.btnHeight
                }

                PanelButton {
                    id: langText
                    anchors {
                        left: parent.left
                        right: parent.right
                        top: editProfText.bottom
                    }
                    text: qsTr("Language")
                    height: settingsFilling.btnHeight
                }

                PanelButton {
                    id: notifText
                    anchors {
                        left: parent.left
                        right: parent.right
                        top: langText.bottom
                    }
                    text: qsTr("Notification and Sounds")
                    height: settingsFilling.btnHeight
                }
            }
        }
    }

    Popup {
        id: addRequest
        width: 600
        height: parent.height - 150
        modal: true
        anchors.centerIn: parent
        background: null
        contentItem: Rectangle{
            color: mainWindow.genIntColor
            anchors.fill: parent
            radius: 10
            border.color: "transparent"
            border.width: 0
        }
    }

    Component.onCompleted: {
        RequestManager.getRequests()
    }
}
