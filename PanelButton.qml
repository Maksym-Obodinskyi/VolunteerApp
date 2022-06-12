import QtQuick 2.0
import QtQuick.Controls 2.15

Rectangle {
    id: root

    property alias text: text.text
    property string genIntColor
    property alias enabled: mouse.enabled
    signal clicked

    color: mouse.pressed ? "#00796b" : mouse.containsMouse ? "#009688" : genIntColor

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            root.clicked()
        }
    }

    Text {
        id: text
        anchors.fill: parent
        font.pixelSize: 18
        color: "white"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }
}
