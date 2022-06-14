import QtQuick 2.0

import QtQuick.Window 2.14
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.0

import session_manager 1.0

Rectangle {
    id: root

    visible: true
    radius: 30

    property alias genIntColor: root.color
    property bool failedToCreate: false
    property bool edit: false

    signal created;
    signal back;
    signal close;

    Text {
        id: title
        text: root.edit ? "Edit Account" : "Create Account"
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
            text: root.edit ? SessionManager.phone : ""
            placeholderText: qsTr("Phone +380...")
        }

        VTextInput {
            id: emailField
            width:  writePhone.inputWidth
            height: 50
            anchors.top: parent.top
            anchors.right: parent.right
            maximumLength: 40
            text: root.edit ? SessionManager.email : ""
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
            text: root.edit ? SessionManager.name : ""
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
            text: root.edit ? SessionManager.lastName : ""
            placeholderText: qsTr("Last name")
        }

        VTextInput {
            id: prevPswd

            width:  writePhone.inputWidth
            height: root.edit ? 50 : 0
            visible: root.edit
            anchors.top: nameField.bottom
            anchors.left: parent.left
            anchors.topMargin: root.edit ? writePhone.inputTopMargins : 0
            maximumLength: 35
            echoMode: TextInput.Password
            placeholderText: qsTr("Previous Password")
        }

        Image {
            id: img
            anchors {
                top: selectPhoto.top
                right: selectPhoto.left
                rightMargin: 12
            }
            source: "qrc:/resources/icons/userPhoto.png"
            height: selectPhoto.height
            width: height
            visible: root.edit
        }

        VButton {
            id: selectPhoto
            height: root.edit ? 50 : 0
            width: 185
            visible: root.edit
            anchors.right: parent.right
            anchors.top: nameField.bottom
            anchors.topMargin: root.edit ? writePhone.inputTopMargins : 0
            text: qsTr("Choose photo")
            onClicked: {
                fileDialog.open()
            }
        }

        VTextInput {
            id: pswdField

            width:  writePhone.inputWidth
            height: 50
            anchors.top: prevPswd.bottom
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
            anchors.top: prevPswd.bottom
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
            text: root.edit ? qsTr("Cancel") : qsTr("Back")
            onClicked: root.edit ? root.close() : back()
        }

        VButton {
            id: nextButton
            text: root.edit ? qsTr("Edit") : qsTr("Create")
            height: 50
            width: 200
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 30

            function edit() {
                if (!phoneField.text.match(/\+[0-9]{12}/)) {
                    isPwsdOk.text = qsTr("Phone is incorrect")
                    return;
                } else if (!emailField.text.match(/(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])/)) {
                    isPwsdOk.text = qsTr("Email is incorrect")
                    return;
                } else if (prevPswd.text.length !== 0) {
                    if (prevPswd.text === SessionManager.password) {
                        isPwsdOk.text = qsTr("Previous password is incorrect")
                    } else if (pswdField.text !== pswdFieldAgain.text) {
                        isPwsdOk.text = qsTr("Passwords are different")
                        return;
                    } else if (pswdField.text.length < 8) {
                        isPwsdOk.text = qsTr("Use at least 8 symbols for password")
                        return;
                    }
                    SessionManager.editAccount(phoneField.text, pswdField.text, nameField.text, lastNameField.text, emailField.text, fileDialog.fileUrl)
                }
                SessionManager.editAccount(phoneField.text, SessionManager.password, nameField.text, lastNameField.text, emailField.text, fileDialog.fileUrl)
            }

            function create() {
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

            onClicked: {
                if (root.edit) {
                    edit()
                } else {
                    create()
                    root.close()
                }
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: qsTr("Choose a photo")
        folder: shortcuts.home
        nameFilters: [ "Image files (*.jpg *.png *.jpeg)" ]
    }
}
