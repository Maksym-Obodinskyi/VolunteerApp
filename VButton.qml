import QtQuick 2.0

Rectangle {
    id: root
    property alias  text: text.text
    property string activeColor: "grey"

    signal clicked

    color: mouseArea.pressed ? activeColor : "white"

    Text {
        id: text
        anchors.centerIn: parent
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked()
    }
}
