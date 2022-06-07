import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Controls 1.4

import "resources/Constants"

Popup {
    id: root

    property string genIntColor:    "#0047b3"

    height: rect.height
    width: 600
    modal: true
    background: null

    contentItem: Item {
        Rectangle {
            id: rect
            color: root.genIntColor
            height: header.height + body.height + 20
            radius: 10
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
                    }
                }
            }

            Item {
                id: body

                property int horMargin: 30
                property int verMargin: 10
                property int fontPixelSize: 17
                height: titleItem.height
                      + descriptionItem.height
                      + categoriesItem.height
                      + dateTimeItem.height
                      + anchors.topMargin

                anchors {
                    top: header.bottom
                    left: parent.left
                    right: parent.right
                    topMargin: 30
                }

                Item {
                    id: titleItem

                    height: titleText.height + textInput.height + anchors.topMargin

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
                        font.pixelSize: body.fontPixelSize

                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter

                        anchors {
                            top: parent.top
                            left: parent.left
                            right: parent.right
                        }
                    }

                    VTextInput {
                        id: textInput

                        placeholderText: qsTr("Walk animals")
                        font.pixelSize: body.fontPixelSize
                        height: 35
                        anchors {
                            top: titleText.bottom
                            left: parent.left
                            right: parent.right
                            topMargin: body.verMargin
                        }
                    }
                }

                Item {
                    id: descriptionItem

                    height: descText.height + descInput.height + anchors.topMargin

                    anchors {
                        top: titleItem.bottom
                        left: parent.left
                        right: parent.right
                        topMargin: body.verMargin
                        leftMargin: body.horMargin
                        rightMargin: body.horMargin
                    }

                    Text {
                        id: descText

                        text: qsTr("Detailed description:")
                        height: contentHeight
                        font.pixelSize: body.fontPixelSize

                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter

                        anchors {
                            top: parent.top
                            left: parent.left
                            right: parent.right
                        }
                    }

                    VTextInput {
                        id: descInput

                        placeholderText: qsTr("Walk animals")
                        font.pixelSize: body.fontPixelSize
                        height: 100
                        anchors {
                            top: descText.bottom
                            left: parent.left
                            right: parent.right
                            topMargin: body.verMargin
                        }
                    }
                }

                Item {
                    id: categoriesItem

                    height: categoriesText.height + categoriesComboBox.height + anchors.topMargin

                    anchors {
                        top: descriptionItem.bottom
                        left: parent.left
                        right: parent.right
                        topMargin: body.verMargin
                        leftMargin: body.horMargin
                        rightMargin: body.horMargin
                    }

                    Text {
                        id: categoriesText

                        text: qsTr("Categories:")
                        height: contentHeight
                        font.pixelSize: body.fontPixelSize

                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter

                        anchors {
                            top: parent.top
                            left: parent.left
                            right: parent.right
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
                            topMargin: body.verMargin
                        }
                    }
                }

                Item {
                    id: dateTimeItem

                    height: calendar.height + anchors.topMargin

                    anchors {
                        top: categoriesItem.bottom
                        left: parent.left
                        right: parent.right
                        topMargin: body.verMargin
                        leftMargin: body.horMargin
                        rightMargin: body.horMargin
                    }

                    Calendar {
                        id: calendar
                        anchors {
                            top: parent.top
                            left: parent.left
                        }
                    }
                }
            }
        }
    }
}
