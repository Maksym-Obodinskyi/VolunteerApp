import QtQuick 2.15
import QtQuick.Window 2.15

import QtLocation 5.15 // Map
import QtQuick.Controls 2.3
import QtPositioning 5.15


ApplicationWindow {
    id: mainWindow

    visibility: "FullScreen"
    visible: true

    Map {
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

    Button {
        id: quit
        anchors {
            top: parent.top
            right: parent.right
        }

        icon.source: "qrc:/resources/icons/exitButton.png"
        icon.width: parent.width
        icon.height: parent.height
        icon.color: "transparent"
        z: 1000
        width: 50 // TODO: size
        height: 50

        background: null

        onClicked:{
            mainWindow.close()
        }
    }

    Rectangle {
        id: menu
        width: 350
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
            leftMargin: -width
        }
        z: 100
        color: "#0047b3"

        Item {
            id: topPanel

            property int panelLeftMargin: 20

            height: 230

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }

            Rectangle {
                id: userPhoto

                anchors {
                    top: parent.top
                    left: parent.left
                    topMargin: topPanel.panelLeftMargin
                    leftMargin: topPanel.panelLeftMargin
                }

                width: 90
                height: 90
                radius: width/2
            }

            Text {
                id: userName

                text: "Maksym"

                anchors {
                    top: userPhoto.bottom
                    left: parent.left
                    topMargin: 20
                    leftMargin: topPanel.panelLeftMargin
                }
            }
            Text {
                id: userNumber

                text: "+380930975704"

                anchors {
                    top: userName.bottom
                    left: parent.left
                    topMargin: 20
                    leftMargin: topPanel.panelLeftMargin
                }
            }
        }

        Rectangle {
            id: panelDel
            color: "black"
            height: 1

            anchors {
                top: parent.top
                topMargin: 230
                left: parent.left
                right: parent.right
            }
        }



    }

    Button {
        id: menuButton
        anchors {
            top: parent.top
            left: parent.left
            leftMargin: 10
            topMargin: 10
        }
        width: 40
        height: 40
        icon.source: "qrc:/resources/icons/menu.png"
        icon.color: "transparent"
        icon.width: parent.width
        icon.height: parent.height
        background: null

        onClicked: { // TODO: Animation onValueChanged
            menu.anchors.leftMargin = 0
        }
    }

}
