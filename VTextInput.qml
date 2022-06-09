import QtQuick 2.0
import QtQuick.Controls 2.15


TextField {
    id: textArea

    placeholderText: qsTr("Enter...")
    background: Rectangle {
        id: root

        color: "white"
        radius:5
    }
}
