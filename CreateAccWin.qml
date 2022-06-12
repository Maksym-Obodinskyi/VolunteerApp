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
            placeholderText: qsTr("Phone +380...")
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

        VText {
            id: isPwsdOk
            text: ""
            visible: true
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: pswdField.bottom
                topMargin: 20
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
                if (!phoneField.text.match(/\+[0-9]{12}/)) {
                    isPwsdOk.text = qsTr("Phone is incorrect")
                    return;
                } else if (pswdField.text !== pswdFieldAgain.text) {
                    isPwsdOk.text = qsTr("Passwords are different")
                    return;
                } else if (!emailField.text.match(/(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])/)) {
                    isPwsdOk.text = qsTr("Email is incorrect")
                    return;
                } else if (pswdField.text.length < 8) {
                    isPwsdOk.text = qsTr("Use at least 8 symbols for password")
                    return;
                } else {
                    isPwsdOk.text = ""
                }

                SessionManager.createAccount(phoneField.text, pswdField.text, nameField.text, lastNameField.text, emailField.text)
            }
        }
    }
}
