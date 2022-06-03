import QtQuick 2.0
import QtQuick.Controls 2.15

Button {
    id: root

    property string btnText: ""
//    readonly property color  genIntColor:          Qt.rgba(0.035, 0.05, 0.066, 1)
    readonly property string genIntColor:        "#0047b3"
    readonly property string genIntFocusedColor: "#0047f3"

    contentItem: Text {
        text: root.text
        font: root.font
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    anchors {
        left: parent.left
        right: parent.right
        top: parent.top
    }

    background: null
    icon.color: focus ? genIntFocusedColor : genIntColor
    font.pixelSize: 15
    text: btnText
}
