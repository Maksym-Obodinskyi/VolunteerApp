import QtQuick 2.12
import QtQuick.Controls 1.4 as QC14
import QtQuick.Controls 2.15
import QtQuick.Controls.Styles 1.4

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
                                      , categoriesComboBox.currentText
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
                        maximumLength: 40
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

                    height: descText.height + descView.height
                          + descText.anchors.topMargin + descView.anchors.topMargin

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

                    ScrollView {
                        id: descView

                        height: 150

                        anchors {
                            top: descText.bottom
                            left: parent.left
                            right: parent.right
                            topMargin: body.controlVerMargin
                        }

                        background: Rectangle {
                            color: "white"
                            radius: 10
                        }


                        TextArea {
                            id: descInput

                            wrapMode: TextEdit.Wrap

                            placeholderText: qsTr("Description...\n                                                                                                                               \n                                                                                                                               \n                                                                                                                               \n                                                                                                                               \n                                                                                                                               ")
                            font.pixelSize: body.fontPixelSize
                            anchors.fill: parent
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
                        model: [ "Food", "Millitary", "Money", "Clothes", "Delivery", "Home", "Animals", "Car", "Devices", "Other" ]

                        anchors {
                            top: categoriesText.bottom
                            left: parent.left
                            right: parent.right
                            topMargin: body.controlVerMargin
                        }

                        delegate: ItemDelegate {
                            width: categoriesComboBox.width
                            contentItem: Text {
                                text: modelData
                                color: "black"
                                font: categoriesComboBox.font
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignLeft
                            }
                            highlighted: categoriesComboBox.highlightedIndex === index
//                            radius: 10
                        }

                        indicator: Canvas {
                            id: canvas
                            x: categoriesComboBox.width - width - categoriesComboBox.rightPadding
                            y: categoriesComboBox.topPadding + (categoriesComboBox.availableHeight - height) / 2
                            width: 12
                            height: 8
                            contextType: "2d"

                            Connections {
                                target: categoriesComboBox
                                function onPressedChanged() { canvas.requestPaint(); }
                            }

                            onPaint: {
                                context.reset();
                                context.moveTo(0, 0);
                                context.lineTo(width, 0);
                                context.lineTo(width / 2, height);
                                context.closePath();
                                context.fillStyle = categoriesComboBox.pressed ? "#00796b" : root.genIntColor;
                                context.fill();
                            }
                        }

                        contentItem: Text {
                            leftPadding: 10
                            z: categoriesComboBox.indicator.width + categoriesComboBox.spacing

                            text: categoriesComboBox.displayText
                            font: categoriesComboBox.font
                            color: "black"
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                        }

                        background: Rectangle {
                            implicitWidth: 120
                            implicitHeight: 40
                            radius: 3
                        }

                        popup: Popup {
                            y: categoriesComboBox.height - 5
                            width: categoriesComboBox.width
                            implicitHeight: contentItem.implicitHeight + 3
                            padding: 0

                            contentItem: ListView {
                                clip: true
                                implicitHeight: 285
                                model: categoriesComboBox.popup.visible ? categoriesComboBox.delegateModel : null
                                currentIndex: categoriesComboBox.highlightedIndex

                                ScrollIndicator.vertical: ScrollIndicator { }
                            }

                            background: Rectangle {
                                radius: 3
                            }
                        }
                    }
                }

                QC14.Calendar {
                    id: calendar

                    width: 350
                    anchors {
                        top: categoriesItem.bottom
                        horizontalCenter: parent.horizontalCenter
                        topMargin: 30
                    }
                }

                VText {
                    id: errorTxt
                    anchors {
                        horizontalCenter: calendar.horizontalCenter
                        top: calendar.bottom
                        topMargin: 8
                    }
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Item {
                    id: controls

                    property int horMargin: 30
                    property int buttonsTopMargin: 60
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
                            if (descInput.length > 150) {
                                errorTxt.text = "Too long description\nMaximum length 150"
                                return;
                            } else if (titleTextInput.length > 40){
                                errorTxt.text = "Too long title\nMaximum length 40"
                                return;
                            }

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
