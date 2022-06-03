import QtQuick 2.0
import QtQuick.Controls 2.15

Button {
    id: quit

    property string uri: ""

    icon.source: uri
    icon.width: parent.width
    icon.height: parent.height
    icon.color: "transparent"
    background: null
}
