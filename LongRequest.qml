import QtQuick 2.0
import QtQuick.Controls 2.3

Popup {
    id: root

    width: 600
    height: 500

    modal: true
    background: null

    property alias genIntColor: content.color

    Overlay.modal: Rectangle {
        color: "#bb101010"
    }

    property alias title: title.text
    property alias description: desc.text
    property alias photo: photo
    property alias name: name.text
    property alias lastName: lastName.text
    property alias phone: phone.text
    property alias email: email.text

    contentItem: Rectangle {
        id: content
        anchors.fill: parent
        radius: 10

        color: root.genIntColor
        property int margins: 20
        property int delMagins: 25

        Item {
            id: header

            height: title.height + headDel.height + headDel.anchors.topMargin

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                topMargin: content.margins
                leftMargin: content.margins
                rightMargin: content.margins
            }

            Text {
                id: title

                height: contentHeight

                text: "Walk animals"

                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                font.pixelSize: 36
                color: "white"
            }

            DelimiterLine {
                id: headDel

                anchors {
                    top: title.bottom
                    left: parent.left
                    right: parent.right
                    topMargin: content.delMagins
                }
            }
        }

        Item {
            id: body
            anchors {
                top: header.bottom
                left: parent.left
                right: parent.right
                topMargin: content.delMagins
                leftMargin: content.margins
                rightMargin: content.margins
            }

            Text {
                id: desc
                height: contentHeight
                horizontalAlignment: Text.AlignLeft

                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                color: "white"
                font.pixelSize: 18

                text: "This signal is ted for each line of text that is laid out during the layout process in plain text or styled text mode. It is not ted in rich text mode. The specified line object provides more details about the line that is currently being laid out. This gives the opportunity to position and resize a line as it is being laid out. It can for example be used to create columns or lay out text around objects. The properties of the specified line object are:"
                wrapMode: Text.WordWrap
            }

            DelimiterLine {
                id: descDel

                anchors {
                    top: desc.bottom
                    left: parent.left
                    right: parent.right
                    topMargin: content.delMagins
                }
            }

            Item {
                id: userInfo

                anchors {
                    top: descDel.bottom
                    left: parent.left
                    right: parent.right
                    topMargin: content.delMagins
                }

                UserPhoto {
                    id: photo
                    anchors {
                        top: parent.top
                        left: parent.left
                    }
                }

                VText {
                    id: name

                    text: "Maksym"

                    anchors {
                        top: parent.top
                        left: photo.right
                        leftMargin: 10
                    }
                }

                VText {
                    id: lastName

                    text: "Obodinskyi"

                    anchors {
                        top: parent.top
                        left: name.right
                        leftMargin: 10
                    }
                }

                VText {
                    id: phone

                    text: "+380930975704"

                    anchors {
                        top: name.bottom
                        left: name.left
                        topMargin: 5
                    }
                }

                VText {
                    id: email

                    text: "m.obodinskyy@nltu.lviv.ua"

                    anchors {
                        top: phone.bottom
                        left: name.left
                        topMargin: 5
                    }
                }
            }
        }
    }
}
