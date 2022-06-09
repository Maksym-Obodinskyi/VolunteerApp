import QtQuick 2.0

import QtQuick.Window 2.14
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

import session_manager 1.0

Rectangle {
    id: root

    visible: true
    color: "#4242aa"

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
    Item {
        id: writePhone
        anchors {
            top: title.bottom
            left: parent.left
            right: parent.right
            topMargin: 50
            leftMargin: 30
            rightMargin: 30
        }

        property int inputWidth:  width / 2 - 10

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
            anchors.topMargin: 20
            maximumLength: 25
            placeholderText: qsTr("Name")
        }

        VTextInput {
            id: lastNameField
            width:  writePhone.inputWidth
            height: 50
            anchors.top: emailField.bottom
            anchors.right: parent.right
            anchors.topMargin: 20
            maximumLength: 25
            placeholderText: qsTr("Last name")
        }

        VTextInput {
            id: pswdField

            width:  writePhone.inputWidth
            height: 50
            anchors.top: nameField.bottom
            anchors.left: parent.left
            anchors.topMargin: 20
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
            anchors.topMargin: 20
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

        VButton {
            id: backButton
            height: 50
            width: 100
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            text: qsTr("Back")
            onClicked: back()
        }

        VButton {
            id: nextButton
            text: qsTr("Create")
            height: 50
            width: 100
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20

            onClicked: {
                if (!isPwsdOk.visible && SessionManager.createAccount(phoneField.text, pswdField.text, nameField.text, lastNameField.text, emailField.text)) {
                    created();
                    isPwsdOk.visible = false
                } else {
                    isPwsdOk.visible = true
                }
            }
        }
    }
}




//VTextInput {
//    id: phoneField
//    width:  parent.width
//    height: 50
//    anchors.top: parent.top
//    anchors.left: parent.left
//    anchors.leftMargin: 20
//    maximumLength: 13
//    placeholderText: qsTr("Enter phone")
//}

//VTextInput {
//    id: pswdField

//    width:  parent.width
//    height: 50
//    anchors.top: phoneField.bottom
//    anchors.left: parent.left
//    anchors.topMargin: 20
//    anchors.leftMargin: 20
//    maximumLength: 35
//    echoMode: TextInput.Password
//    placeholderText: qsTr("Enter password")
//    onTextChanged: {
//        if (pswdField.text !== pswdFieldAgain.text) {
//            isPwsdOk.text = qsTr("Passwords are different")
//        } else {
//            isPwsdOk.text = ""
//        }
//    }
//}

//VTextInput {
//    id: pswdFieldAgain

//    width:  parent.width
//    height: 50
//    anchors.top: pswdField.bottom
//    anchors.left: parent.left
//    anchors.topMargin: 20
//    anchors.leftMargin: 20
//    maximumLength: 35
//    echoMode: TextInput.Password
//    placeholderText: qsTr("Repeat your password")

//    onTextChanged: {
//        if (pswdField.text !== pswdFieldAgain.text) {
//            isPwsdOk.text = qsTr("Passwords are different")
//        } else {
//            isPwsdOk.text = ""
//        }
//    }
//}

//Text {
//    id: isPwsdOk
//    anchors {
//        left: parent.left
//        right: parent.right
//        top: pswdFieldAgain.bottom
//        topMargin: 20
//        leftMargin: 20
//    }
//}
