import QtQuick 2.0
MovingInAnOutFrame {
    id:root
    width: parent.width
    height: parent.height
    property var letterRefArray : [{"name":"a"},{"name":"b"},{"name":"c"},{"name":"d"},{"name":"e"},{"name":"f"},{"name":"g"},{"name":"h"},{"name":"i"},{"name":"j"},{"name":"k"},{"name":"l"},{"name":"m"},{"name":"n"},{"name":"o"},{"name":"p"},{"name":"q"},{"name":"r"},{"name":"s"},{"name":"t"},{"name":"u"},{"name":"v"},{"name":"w"},{"name":"x"},{"name":"y"},{"name":"z"}]
    property var letters: [{"name":"a"}]
    property int letterSize: 70;
    signal letterSelected(string letter)

    ListModel {
        id: letterModel
        ListElement {name:"a"}
    }

    Timer{
        id: populateTimer
        interval: 10;
        running: true;
        repeat: true;
        onTriggered: {
            var letter = root.letterRefArray[letterModel.count]
//            console.log("adding ", JSON.stringify(letter));
            letterModel.append(letter);
            if(letter.name === "z")
                running = false;

        }
    }

    Image{
        id: grassTexture
        source:"img/grass.png"
        visible: false
    }


    Canvas{
        id:grass
        width: parent.width
        height: 3* parent.height / 5
        anchors.bottom: parent.bottom
        contextType: "2d"
        onPaint: {
            if(!context)
                return;
            var elemW = width / 12;
            var hillH =  150;
            context.beginPath();
            context.moveTo(width, height);
            drawingTools.createPath(context, [
                            {x:width + elemW,y:0},
                            {x:width,y:0},
                            {x:11*elemW,y:hillH / 2},
                            {x:10*elemW,y:hillH },
                            {x:6*elemW,y:0 },
                            {x:2*elemW,y:hillH },
                            {x:1*elemW,y:height},
                            {x:0,y:height }]);
            context.lineTo(0,height);
            context.closePath();
            var pattern = context.createPattern("img/grass.png", "repeat");
            context.fillStyle = pattern;
            context.fill();
        }
    }

    Image {
        id: tree
        source: "img/arbre.png"
        y:root.height / 3 - 50;
        x:root.width*7/12;
        height: parent.height/3
        fillMode: Image.PreserveAspectFit
    }

    Flow{
        width: 2/3 * root.width
        anchors.bottom: grass.bottom
        anchors.right: grass.right
        anchors.rightMargin: 50
        anchors.bottomMargin: 50

        spacing: 10
        Repeater {
            id:allLetters
            model:letterModel
            LetterDisplay{
                width:letterSize
                height: letterSize
                letter:name
                onSelected: {
                    root.letterSelected(name)
                }
            }
        }
        add: Transition {
            ParallelAnimation{
                NumberAnimation { properties: "x"; from: -100;duration: 1000; easing.type: Easing.OutBounce }
                NumberAnimation { properties: "y"; from: -100;duration: 1000; easing.type: Easing.OutBounce }
            }

        }
        populate: Transition {
              NumberAnimation { properties: "x,y"; from: 0; duration: 100; easing.type: Easing.OutBounce }
          }
    }
    Component.onCompleted: {
        startSceneAnimation()
    }
    function startSceneAnimation(){
        if(visible){
            letterModel.clear();
            populateTimer.running = true;
        }
    }    
    xWhenHidden: parent.width +100
//    xWhenShown : -100

}
