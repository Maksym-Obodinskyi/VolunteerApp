import QtQuick 2.0
import QtQuick.Window 2.14
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

Rectangle {
    id: root
    width: 500
    height: 400
    visible: true

    Text {
        id: title
        text: "Sign in"
        height: 40
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 20
        horizontalAlignment: Text.AlignHCenter
        font.pointSize: 20
    }
    Item {
        id: writePhone
        width: parent.width -40
        anchors.top: title.bottom
        anchors.topMargin: 50
        TextField {
            id: phoneField
            width:  parent.width
            height: 50
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 20
            placeholderText: qsTr("Enter phone")
        }

        Label {
            id: forgetPhone
            anchors.top: phoneField.bottom
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.topMargin: 20
            text: "Forgot your phone?"
            MouseArea{
                anchors.fill: parent
                onClicked: forgetPhone.text = "Yes i forget"
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
            text: "Create new account"
            MouseArea{
                anchors.fill: parent
                onClicked: ill.text = "Go create account"
            }
        }

        Button {
            id: nextButton
            text: "Next"
            height: 50
            width: 100
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20

            onClicked: phoneField.text += "Read"
        }
    }
}
