import QtQuick 2.0

Rectangle {
    id: root
    property alias  text: text.text
    property string activeColor: "grey"
    radius: 10

    signal clicked

    color: mouseArea.pressed ? activeColor : "white"

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
