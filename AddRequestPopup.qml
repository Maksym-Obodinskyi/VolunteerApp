import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls 2.15

import "resources/Constants"
import request_manager 1.0

Popup {
    id: root

    property alias genIntColor: rect.color
    property string fontColor:      "white"

    height: rect.height
    width: 600
    modal: true
    background: null

    signal getLocation;

    function addRequest(latitude, longitude) {
        RequestManager.addRequest(latitude, longitude
                                      , titleTextInput.text
                                      , descInput.text
                                      , calendar.data);
    }

    function clear() {
        titleTextInput.text = ""
        descInput.text = ""
    }

    Overlay.modal: Rectangle {
        color: "#bb101010"
    }

    contentItem: Item {
        Rectangle {
            id: rect
            height: header.height + body.height + 30
            radius: 30
            anchors {
                left: parent.left
                right: parent.right
            }

            Item {
                id: header

                height: headerText.height + headerDelimiter.height
                anchors {
                    left:   parent.left
                    right:  parent.right
                    top:    parent.top
                }

                Text {
                    id: headerText

                    height: 100
                    text: qsTr("Create your request")
                    font.pixelSize: 32
                    color: root.fontColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                    }
                }

                DelimiterLine {
                    id: headerDelimiter
                    anchors {
                        top: headerText.bottom
                        left: parent.left
                        right: parent.right
                        leftMargin: rect.radius
                        rightMargin: rect.radius
                    }
                }
            }

            Item {
                id: body

                property int horMargin: 30
                property int controlVerMargin: 8
                property int textVerMargin: 20
                property int fontPixelSize: 17
                height: titleItem.height
                      + descriptionItem.height
                      + categoriesItem.height
                      + controls.height
                      + calendar.height + calendar.anchors.topMargin

                anchors {
                    top: header.bottom
                    left: parent.left
                    right: parent.right
                }

                Item {
                    id: titleItem

                    height: titleText.height + titleTextInput.height
                          + titleText.anchors.topMargin + titleTextInput.anchors.topMargin

                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        leftMargin: body.horMargin
                        rightMargin: body.horMargin
                    }

                    Text {
                        id: titleText

                        text: qsTr("Title:")
                        height: contentHeight
                        color: root.fontColor
                        font.pixelSize: body.fontPixelSize

                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter

                        anchors {
                            top: parent.top
                            left: parent.left
                            right: parent.right
                            topMargin: body.textVerMargin
                        }
                    }

                    VTextInput {
                        id: titleTextInput

                        placeholderText: qsTr("Walk animals")
                        font.pixelSize: body.fontPixelSize
                        height: 35
                        anchors {
                            top: titleText.bottom
                            left: parent.left
                            right: parent.right
                            topMargin: body.controlVerMargin
                        }
                    }
                }

                Item {
                    id: descriptionItem

                    height: descText.height + descInput.height
                          + descText.anchors.topMargin + descInput.anchors.topMargin

                    anchors {
                        top: titleItem.bottom
                        left: parent.left
                        right: parent.right
                        leftMargin: body.horMargin
                        rightMargin: body.horMargin
                    }

                    Text {
                        id: descText

                        text: qsTr("Detailed description:")
                        height: contentHeight
                        color: root.fontColor
                        font.pixelSize: body.fontPixelSize

                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter

                        anchors {
                            top: parent.top
                            left: parent.left
                            right: parent.right
                            topMargin: body.textVerMargin
                        }
                    }

                    TextArea {
                        id: descInput

                        placeholderText: qsTr("Description...")
                        font.pixelSize: body.fontPixelSize
                        height: 100
                        anchors {
                            top: descText.bottom
                            left: parent.left
                            right: parent.right
                            topMargin: body.controlVerMargin
                        }

                        background: Rectangle {
                            color: "white"
                            radius:5
                        }
                    }
                }

                Item {
                    id: categoriesItem

                    height: categoriesText.height + categoriesComboBox.height
                          + categoriesText.anchors.topMargin + categoriesComboBox.anchors.topMargin

                    anchors {
                        top: descriptionItem.bottom
                        left: parent.left
                        right: parent.right
                        leftMargin: body.horMargin
                        rightMargin: body.horMargin
                    }

                    Text {
                        id: categoriesText

                        text: qsTr("Categories:")
                        height: contentHeight
                        color: root.fontColor
                        font.pixelSize: body.fontPixelSize

                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter

                        anchors {
                            top: parent.top
                            left: parent.left
                            right: parent.right
                            topMargin: body.textVerMargin
                        }
                    }

                    ComboBox {
                        id: categoriesComboBox
                        width: 200
                        model: [ "Food", "Millitary", "Money", "Clothes", "Delivery", "Home" ]
                        anchors {
                            top: categoriesText.bottom
                            left: parent.left
                            right: parent.right
                            topMargin: body.controlVerMargin
                        }
                    }
                }

                Calendar {
                    id: calendar

                    width: 350
                    anchors {
                        top: categoriesItem.bottom
                        horizontalCenter: parent.horizontalCenter
                        topMargin: 30
                    }
                }

                Item {
                    id: controls

                    property int horMargin: 30
                    property int buttonsTopMargin: 40
                    property int buttonsHeight: 50
                    property int buttonsWidth: 140

                    height: Math.max(addRequest.height, cancelRequest.height)
                          + Math.max(addRequest.anchors.topMargin, cancelRequest.anchors.topMargin)
                    width: calendar.width

                    anchors {
                        top: calendar.bottom
                        horizontalCenter: calendar.horizontalCenter
                    }

                    VButton {
                        id: addRequest

                        text: "Post"
                        height: controls.buttonsHeight
                        width: controls.buttonsWidth

                        anchors {
                            top: parent.top
                            left: parent.left
                            topMargin: controls.buttonsTopMargin
                        }
                        onClicked: {
                            root.getLocation()
                            root.close()
                        }
                    }

                    VButton {
                        id: cancelRequest

                        text: "Cancel"
                        height: controls.buttonsHeight
                        width: controls.buttonsWidth

                        anchors {
                            top: parent.top
                            right: parent.right
                            topMargin: controls.buttonsTopMargin
                        }

                        onClicked: {
                            root.close()
                        }
                    }
                }
            }
        }
    }
}
