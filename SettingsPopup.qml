import QtQuick 2.0
import QtQuick.Controls 2.3

Popup {
    id: root

    property int genLeftMargin: 20
    property string fontColor:  "white"

    visible: false
    modal: true
    background: null

    signal editAcc

    function open() {
        visible = true
    }

    Overlay.modal: Rectangle {
        color: "#bb101010"
    }

    contentItem: Rectangle {
        id: settingsRectangle
        anchors.fill: parent
        color: mainWindow.genIntColor
        radius: 30

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
                color: root.fontColor
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
                color: root.fontColor
                anchors {
                    top: settingsTextHeader.bottom
                    left: settingsUserPhoto.right
                    leftMargin: root.genLeftMargin
                }


            }

            Text {
                id: settingsUserNumber
                text: mainWindow.userNumber
                color: root.fontColor
                anchors {
                    left: settingsUserPhoto.right
                    top: settingsUserName.bottom
                    leftMargin: root.genLeftMargin
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
                    root.close()
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
//                enabled: false
                genIntColor: settingsRectangle.color

                text: qsTr("editProfile")
                height: settingsFilling.btnHeight

                onClicked: {
                    editAcc();
                }
            }

            PanelButton {
                id: langText
                anchors {
                    left: parent.left
                    right: parent.right
                    top: editProfText.bottom
                }
                enabled: false
                genIntColor: settingsRectangle.color

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
                enabled: false
                genIntColor: settingsRectangle.color

                text: qsTr("Notification and Sounds")
                height: settingsFilling.btnHeight
            }
        }
    }
}
