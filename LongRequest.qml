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
    property string photo: ""
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

                text: root.title

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

                text: root.description
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

                    uri: root.photo

                    anchors {
                        top: parent.top
                        left: parent.left
                    }
                }

                VText {
                    id: name

                    anchors {
                        top: parent.top
                        left: photo.right
                        leftMargin: 10
                    }
                }

                VText {
                    id: lastName

                    text: root.lastName

                    anchors {
                        top: parent.top
                        left: name.right
                        leftMargin: 10
                    }
                }

                VText {
                    id: phone

                    text: root.phone

                    anchors {
                        top: name.bottom
                        left: name.left
                        topMargin: 5
                    }
                }

                VText {
                    id: email

                    text: root.email

                    anchors {
                        top: phone.bottom
                        left: name.left
                        topMargin: 5
                    }
                }
            }
        }
    }

    onPhoneChanged: {
        root.photo = "file:///home/maksym/.VolunteerApp/" + root.phone + ".png"
    }
}
