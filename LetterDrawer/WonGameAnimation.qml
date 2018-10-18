import QtQuick 2.0
import QtMultimedia 5.8
Item {
    id:root
    visible: bounceAnimation.running;
    anchors.fill: parent
    state : "out"
    property int xWhenFinished: 100
    signal animationDone();
    function startAnimation(){
        bounceAnimation.start();
        claps.play();
    }
    MediaPlayer{
        id: claps
        source: "sounds/claps.wav"
    }

    Image {
        id: mark
        source: "img/bigcheck.png"
//        width: 0.5*letterGame.width
        x: letterGame.width / 2
        fillMode: Image.PreserveAspectFit
        transform: Scale {
                    id: scaleTransform
                    property real scale: 1
                    xScale: scale
                    yScale: scale
        }
        Behavior on x {
            PropertyAnimation {
                target: mark;
                properties: "x";
                duration: 1000;
            }
        }
        Behavior on y {
            PropertyAnimation {
                target: mark;
                properties: "y";
                duration: 1000;
            }
        }
        SequentialAnimation {
            id: bounceAnimation
            loops: 1
                PropertyAnimation {
                    target: scaleTransform
                    properties: "scale"
                    from: 1.0
                    to: 2.0
                    duration: 500
                }

            ParallelAnimation{
                PropertyAnimation {
                    target: scaleTransform
                    properties: "scale"
                    from: 2.0
                    to: toolsHeight / 400 * 0.33;
                    duration: 1000
                    easing.type : Easing.OutQuad
                }
                PropertyAnimation {
                    target: mark
                    properties: "x"
                    to: xWhenFinished
                    duration: 1000
                    easing.type : Easing.OutQuad
                }
            }
            onRunningChanged: {
                if(!running){
                    root.animationDone();
                }

//                root.visible = running;
            }
        }
    }
//    PropertyAnimation{
//        id:moveIn
//        target: mark
//        properties: "width"
//        from : 0.5 * parent.width
//        to : 0.33 * toolsHeight
//        duration: 2000
//    }


}
