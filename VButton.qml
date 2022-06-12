import QtQuick 2.0

Rectangle {
    id: root
    property alias  text: text.text
    property string pressedColor: "#bdbdbd"
    property string defColor: "white"
    property string hoveredColor: "#e0e0e0"
    property alias textColor: text.color
    property alias font: text.font
    radius: 10

    signal clicked

    color: mouseArea.pressed ? pressedColor : mouseArea.containsMouse ? hoveredColor : defColor

    Text {
        id: text
        font.pixelSize: 17
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked()
    }
}
