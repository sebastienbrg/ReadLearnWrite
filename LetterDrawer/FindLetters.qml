import QtQuick 2.0

Item {
    id:root
    anchors.fill  : parent
    property int letterSize: 70;
    signal won();
    ListModel {
        id: letterModel
    }
    Flow{
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        //anchors.margins: toolsHeight
        spacing: 10
        Repeater {
            id:allLetters
            model:letterModel
            LetterDisplay{
                width:letterSize
                height: letterSize
                x:letterX
                y:letterY
                letter:name
                onSelected: {
                    if(name === letterManager.letter){
                        root.letterSelected(name)
                        validated = true;
                    } else {

                    }
                }
            }
        }
        add: Transition {
            ParallelAnimation{
                NumberAnimation { properties: "x"; duration: 1000; easing.type: Easing.OutQuad }
                NumberAnimation { properties: "y"; duration: 1000; easing.type: Easing.OutQuad }
            }

        }
        populate: Transition {
              NumberAnimation { properties: "x,y"; from: 0; duration: 100; easing.type: Easing.OutBounce }
          }
    }
    function startSceneAnimation(){
        letterModel.clear();
        populateTimer.running = true;
    }
    property int maxLetterCount: 60
    property int lettersToFind : 0;
    property int foundLetters : 0;
    function getRandomLetter(){
        var name;
        var letterX;
        var letterY;
        if(Math.random() < 0.12){
            name = letterManager.letter;
        } else {
            name = String.fromCharCode('a'.charCodeAt(0) + Math.floor(Math.random() * 26));
        }
        if(name === letterManager.letter){
            lettersToFind++;
        }
        letterX = -10*letterSize + Math.random() * (width+20*letterSize);
        if(letterX > width || letterX < -letterSize){
            letterY = (Math.random() > 0.5)?-100:height;
        } else {
            letterY = Math.random() * height;
        }
        letterX = Math.min(width, letterX);
        letterX = Math.max(-letterSize, letterX);
        letterY = Math.min(height, letterY);
        letterY = Math.max(-letterSize, letterY);

        var theLetter = {name:name, letterX:letterX, letterY:letterY};
        return theLetter;
    }

    Timer{
        id: populateTimer
        interval: 10;
        running: true;
        repeat: true;
        onTriggered: {

            letterModel.append(getRandomLetter());
            if(letterModel.count === maxLetterCount)
                running = false;
        }
    }
    function letterSelected(name){
        foundLetters++;
        if(foundLetters == lettersToFind){
            root.won();
        }
    }

}
