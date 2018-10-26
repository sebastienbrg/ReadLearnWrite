import QtQuick 2.0

Item {
    id: root;
    property int index;
    property string name;
    property string source;
    width: parent.width
    height: 25
    property int imgMargin: 2
    signal clicked();

    Rectangle{
        anchors.fill: root
        color: (index%2 == 0) ? "lightgrey" : "white";
        Row{
            spacing: imgMargin*2;
            Image{
                x:0
                y:imgMargin;
                height: root.height-2*imgMargin;
                source: root.source
                fillMode: Image.PreserveAspectFit
            }

            Text {
                height: root.height
                text : root.name
                verticalAlignment: Text.AlignVCenter;
            }
        }
        MouseArea{
            anchors.fill: parent
            onClicked: root.clicked();
        }
    }
}
