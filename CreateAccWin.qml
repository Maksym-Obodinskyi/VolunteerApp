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
    property bool failedToCreate: false

    signal created;
    signal back;

    Text {
        id: title
        text: "Create Account"
        height: 40
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 20
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
            leftMargin: 30
            rightMargin: 30
        }

        property int inputWidth:  width / 2 - 15
        property int inputTopMargins: 20

        VTextInput {
            id: phoneField
            width:  writePhone.inputWidth
            height: 50
            anchors.top: parent.top
            anchors.left: parent.left
            maximumLength: 13
            placeholderText: qsTr("Phone")
        }

        VTextInput {
            id: emailField
            width:  writePhone.inputWidth
            height: 50
            anchors.top: parent.top
            anchors.right: parent.right
            maximumLength: 40
            placeholderText: qsTr("Email")
        }

        VTextInput {
            id: nameField
            width:  writePhone.inputWidth
            height: 50
            anchors.top: phoneField.bottom
            anchors.left: parent.left
            anchors.topMargin: writePhone.inputTopMargins
            maximumLength: 25
            placeholderText: qsTr("Name")
        }

        VTextInput {
            id: lastNameField
            width:  writePhone.inputWidth
            height: 50
            anchors.top: emailField.bottom
            anchors.right: parent.right
            anchors.topMargin: writePhone.inputTopMargins
            maximumLength: 25
            placeholderText: qsTr("Last name")
        }

        VTextInput {
            id: pswdField

            width:  writePhone.inputWidth
            height: 50
            anchors.top: nameField.bottom
            anchors.left: parent.left
            anchors.topMargin: writePhone.inputTopMargins
            maximumLength: 35
            echoMode: TextInput.Password
            placeholderText: qsTr("Password")
            onTextChanged: {
                if (pswdField.text !== pswdFieldAgain.text) {
                    isPwsdOk.text = qsTr("Passwords are different")
                } else {
                    isPwsdOk.text = ""
                }
            }
        }

        VTextInput {
            id: pswdFieldAgain

            width:  writePhone.inputWidth
            height: 50
            anchors.top: lastNameField.bottom
            anchors.right: parent.right
            anchors.topMargin: writePhone.inputTopMargins
            maximumLength: 35
            echoMode: TextInput.Password
            placeholderText: qsTr("Confirm")
            onTextChanged: {
                if (pswdField.text !== pswdFieldAgain.text) {
                    isPwsdOk.text = qsTr("Passwords are different")
                } else {
                    isPwsdOk.text = ""
                }
            }
        }

        Text {
            id: isPwsdOk
            text: qsTr("Passwords are different")
            visible: root.failedToCreate
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
        height: 50

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            leftMargin: 30
            rightMargin: 30
        }

        VButton {
            id: backButton
            height: 50
            width: 200
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 30
            text: qsTr("Back")
            onClicked: back()
        }

        VButton {
            id: nextButton
            text: qsTr("Create")
            height: 50
            width: 200
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 30

            onClicked: {
                if (!isPwsdOk.visible) {
                    SessionManager.createAccount(phoneField.text, pswdField.text, nameField.text, lastNameField.text, emailField.text)
                }
            }
        }
    }
}
