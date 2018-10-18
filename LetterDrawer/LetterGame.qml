import QtQuick 2.0

MovingInAnOutFrame {
    id:root
    width: parent.width
    height: parent.height
    xWhenHidden: -1 * width
    x:-parent.width
    property int currentStateIndex: 0
    signal goBackToMenu();
    state : "start"
    Component.onCompleted: {
        console.log("LetterGame : xWhenHidden ",xWhenHidden, parent.width, width);
    }
    onWidthChanged: {
        console.log("LetterGame width changed : xWhenHidden ",xWhenHidden, parent.width, width);
    }

    states: [
        State{
            name: "start"
            PropertyChanges {target: animCanvas; visible: true}
            PropertyChanges {target: drawTheLetter; visible: false}
            PropertyChanges {target: findThemLetters; visible: false}
            PropertyChanges {target: root; currentStateIndex: 0}
        },
        State{
            name: "Draw"
            PropertyChanges {target: animCanvas; visible: false}
            PropertyChanges {target: drawTheLetter; visible: true}
            PropertyChanges {target: findThemLetters; visible: false}
            PropertyChanges {target: root; currentStateIndex: 1}
        },
        State{
            name: "Find"
            PropertyChanges {target: animCanvas; visible: false}
            PropertyChanges {target: drawTheLetter; visible: false}
            PropertyChanges {target: findThemLetters; visible: true}
            PropertyChanges {target: root; currentStateIndex: 2}
        }
    ]
    function repaint(){
        drawTheLetter.repaint()
    }
    function play(){
        state = "start";
    }
    onEnterAnimDone: {
        animCanvas.playAnim()
    }
    function reset(){
        repaint();
        play();
    }
    property int nextStepIndex : 0;
    function currentGameWon(){
        if(root.currentStateIndex === 0){
            moveToNextState();
        } else {
            wonAnim.xWhenFinished = ((root.currentStateIndex+1) +0.67) * toolsHeight;
            wonAnim.startAnimation();
        }
    }
    function moveToNextState(){

        tools.buttonModel.setProperty(root.currentStateIndex+1, "validated", true);
        if((root.currentStateIndex +1)< root.states.length ){
            root.state = states[root.currentStateIndex+1].name;
            tools.setCurrentIndex(root.currentStateIndex+1)
        }
    }

    Image{
        id: sandTexture
        source:"img/sand.png"
        visible: false
    }
    Canvas{
        id:island
        width: 1* parent.width / 2
        height: 1* parent.height / 3
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 50
        contextType: "2d"
        onPaint: {
            if(!context)
                return;
            var elemW = width / 12;
            var hillH =  150;
            context.beginPath();
            context.moveTo(width, height);
            drawingTools.createPath(context, [
                            {x:10*elemW,y:height },
                            {x:6*elemW,y:0 },
                            {x:2*elemW,y:height },
                            {x:0,y:height }
                            ]);
            context.lineTo(0,height);
            context.closePath();
            var pattern = context.createPattern("img/sand.png", "repeat");
            context.fillStyle = pattern;
            context.fill();
        }
    }
    Image{
        id: sand
        source:"img/palmier.png"
        anchors.bottom: island.bottom
        anchors.bottomMargin: 10
        x:parent.width /4 - width

    }

    LetterAnimCanvas {
        id:animCanvas
        anchors.fill: parent
        y:toolsHeight
        x:0
        letter: letterManager.letter
        moves: letterManager.moves
        onAnimFinished: root.currentGameWon()
    }
    DrawTheLetter{
        id:drawTheLetter
        anchors.fill: parent
        moves: letterManager.moves
        smoothMoves : letterManager.smoothMoves
        onLetterCorrectlyWritten: {
            console.log("OK !!! ");
            currentGameWon();
        }
    }
    FindLetters{
        id:findThemLetters
        onWon: {
            currentGameWon()
        }
    }

    GenericToolBox{
        id: tools;
        onBtnClicked: function(btnName){
            console.log("Btn clicked : ", btnName);
            switch(btnName){
            case "GoBack":
                root.goBackToMenu();
                break;
            case "Look":
                if(root.state === "start"){

                } else {
                    root.state = "start"
                    animCanvas.playAnim();
                }
                break;
            case "Find":
                animCanvas.stop();
                findThemLetters.startSceneAnimation();
                root.state = "Find"
                break;
            case "Draw":
                root.state = "Draw"
                break;
            }

        }
        buttonModel:
            ListModel{
                ListElement {text:"GoBack"; checkable:false; imgSrc:"img/carroussel.png"; validated:false; isCurrent:false}
                ListElement {text:"Look"; checkable:false; imgSrc:"img/eye.png"; validated:false; isCurrent:false}
                ListElement {text:"Draw"; checkable:false; imgSrc:"img/draw.png"; validated:false; isCurrent:false}
                ListElement {text:"Find"; checkable:false; imgSrc:"img/binoculars.png"; validated:false; isCurrent:false}
            }
    }
    WonGameAnimation{
        id:wonAnim
        onAnimationDone: moveToNextState();
    }
}
