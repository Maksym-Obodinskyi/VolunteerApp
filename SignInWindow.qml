import QtQuick 2.0
import QtQuick.Window 2.14
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

import session_manager 1.0

Rectangle {
    id: root

    visible: true
    color: "#4242aa"

    function failedtoSignIn() {
        isPwsdOk.visible = true
    }

    signal close;

    Text {
        id: title
        text: "Sign in"
        height: 40
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 20
        horizontalAlignment: Text.AlignHCenter
        font.pointSize: 20
        color: "white"
    }

    Item {
        id: writePhone
        width: parent.width -40
        anchors.top: title.bottom
        anchors.topMargin: 50

        VTextInput {
            id: phoneField
            width:  parent.width
            height: 50
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 20
            maximumLength: 13
            placeholderText: qsTr("Enter phone")
        }

        VTextInput {
            id: pswdField

            width:  parent.width
            height: 50
            anchors.top: phoneField.bottom
            anchors.left: parent.left
            anchors.topMargin: 20
            anchors.leftMargin: 20
            maximumLength: 35
            echoMode: TextInput.Password
            placeholderText: qsTr("Enter password")
        }

        Text {
            id: isPwsdOk
            text: qsTr("Please try again")
            visible: false
            anchors {
                left: parent.left
                right: parent.right
                top: pswdField.bottom
                topMargin: 20
                leftMargin: 20
            }
        }
    }

    Item {
        width: parent.width
        height: 50
        anchors.bottom: parent.bottom

        Label {
            id: ill
            anchors.left: parent.left
            height: parent.height
            anchors.leftMargin: 20
            anchors.bottom: parent.bottom
            text: qsTr("Create account")
            color: "white"
            MouseArea{
                anchors.fill: parent
                onClicked: close()
            }
        }

        Button {
            id: nextButton
            text: qsTr("Sign in")
            height: 50
            width: 100
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20

            onClicked: {
                SessionManager.signIn(phoneField.text, pswdField.text)
            }
        }
    }

    Component.onCompleted: {
        pswdField.text = SessionManager.password
        phoneField.text = SessionManager.phone
    }
}
