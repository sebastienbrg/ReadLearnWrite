import QtQuick 2.0

Item {
    id: root;
    property int index;
    property string name;
    width: parent.width
    height: 25

    Rectangle{
        anchors.fill: root
        color: (index%2 == 0) ? "lightgrey" : "white";
        Text {
            text : root.name
        }
    }
}
