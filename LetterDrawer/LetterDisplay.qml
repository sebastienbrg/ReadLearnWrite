import QtQuick 2.0
import QtMultimedia 5.8
Item {
    id:root
    property string letter;
    width: 50
    height: 50
    signal selected()
    property bool validated: false

    MediaPlayer {
            id: playMusic
    }
    Rectangle{
        id:frame
        anchors.fill : parent
        radius: width / 2.
        color: "white"
        opacity: 0.5

        MouseArea{
            anchors.fill: parent;
            hoverEnabled: true
            onEntered: frame.color = "yellow";
            onExited: frame.color = "white"
            onPressed: {
//                playMusic.source = "sounds/" + letter +".wav"
//                console.log("Playing", playMusic.source)
//                playMusic.play();
                root.selected();
            }
        }
    }

    Text{
        text:root.letter
        font.family: "Pere Castor"
        font.pointSize: 40
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Validable{

    }

}
