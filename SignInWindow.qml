import QtQuick 2.0
import QtQuick.Window 2.14
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

import session_manager 1.0

Rectangle {
    id: root

    visible: true
    radius: 30

    property alias genIntColor: root.color
    property bool failedToSignIn: false

    signal createAccount;

    Text {
        id: title
        text: "Sign in"
        height: 40
        width: parent.width
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: 20
        }

        horizontalAlignment: Text.AlignHCenter
        font.pointSize: 20
        color: "white"
    }

    DelimiterLine {
        id: headerDel
        property int margins: root.radius
        anchors {
            top: title.bottom
            left: parent.left
            right: parent.right
            topMargin: 10
            leftMargin: margins
            rightMargin: margins
        }
    }

    Item {
        id: writePhone

        anchors {
            top: headerDel.bottom
            left: parent.left
            right: parent.right
            topMargin: 40
            leftMargin: root.radius
            rightMargin: root.radius
        }

        VTextInput {
            id: phoneField

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }

            height: 50

            maximumLength: 13
            placeholderText: qsTr("Enter phone")
        }

        VTextInput {
            id: pswdField

            height: 50

            anchors {
                top: phoneField.bottom
                left: parent.left
                right: parent.right
                topMargin: 20
            }
            maximumLength: 35
            echoMode: TextInput.Password
            placeholderText: qsTr("Enter password")
        }

        Text {
            id: isPwsdOk
            text: qsTr("Please try again")
            visible: root.failedToSignIn
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
        id: controls
        height: 50

        property int buttonWidth: 160

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            leftMargin: root.radius
            rightMargin: root.radius
            bottomMargin: root.radius
        }


        VButton {
            id: ill
            height: parent.height
            width: controls.buttonWidth
            anchors {
                left: parent.left
                bottom: parent.bottom
            }

            text: qsTr("Create account")
            onClicked: root.createAccount()
        }

        VButton {
            id: nextButton
            text: qsTr("Sign in")
            height: parent.height
            width: controls.buttonWidth
            anchors {
                right: parent.right
                bottom: parent.bottom
            }

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
