import QtQuick 2.0

Item {
    id:root
    property var moves : []
    property string letter
    property int currentAnimPoint: 0
    property int moveAnimPercentage: 0
    signal animFinished()
    function stop(){
        drawAnim.stop();
        currentAnimPoint = 0;
        moveAnimPercentage = 0;
    }

    NumberAnimation {
        id:drawAnim
        target: root
        property: "currentAnimPoint"
        duration: 3000
        from: 0;
        to: moves.length -1
        //easing.type: Easing.InOutQuad
        onStopped: { animFinished()}
    }
    NumberAnimation {
        id:movePointAnim
        target: root
        property: "moveAnimPercentage"
        from: 0;
        to: 100;
    }


    onCurrentAnimPointChanged: {
        currentPointLayer.requestPaint();
        pathLayer.requestPaint();
    }
    onMoveAnimPercentageChanged: {
        currentPointLayer.requestPaint();
    }

    function playAnim(){
        currentAnimPoint = 0;
        console.log("Starting anim " + moves.length + " " + drawAnim.to);
        currentPointLayer.reset();
        pathLayer.reset();
        drawAnim.start();
    }

    onMovesChanged: {
//        console.log("New move for letter " + root.letter + " length : " + moves.length );
        pathLayer.reset();
    }


    Canvas
    {
        id: pathLayer
        anchors.fill: parent;
        antialiasing:true;
        smooth:true
        property string letter : root.letter
        property bool letterAnimIsPaused : false;
        property int lastDrawnMoveIndex : 0;


        function reset(){
            if(available){
                var ctx = getContext("2d");
                ctx.reset();
                drawAnim.stop();
                movePointAnim.stop();
                lastDrawnMoveIndex = 0;
                requestPaint();
            }
        }

        Timer {
            id: timer;
        }
        function setTimeout(cb, delayTime) {
            timer.interval = delayTime;
            timer.repeat = false;
            timer.triggered.connect(cb);
            timer.triggered.connect(function() {
                timer.triggered.disconnect(cb); // This is important
            });
            timer.start();
        }

        function setAnimInfoForMove(){
            var toMove = moves[lastDrawnMoveIndex];
            var fromMove = moves[lastDrawnMoveIndex-1];

            currentPointLayer.moveEndX = toMove.x;
            currentPointLayer.moveEndY = toMove.y;
            currentPointLayer.moveStartX = fromMove.x;
            currentPointLayer.moveStartY = fromMove.y;

            var pixPerMs = 0.15;
            var dist = Math.sqrt( Math.pow((toMove.x - fromMove.x),2) +  Math.pow((toMove.y - fromMove.y),2));
            var duration = dist / pixPerMs;


//            console.log("Will move from "+ fromMove.x + ";" + fromMove.y + " to " + toMove.x + ";" + toMove.y + " in " + duration + "ms");
            movePointAnim.duration = duration;
            movePointAnim.start();
        }

        function pauseAnim(){
            if(letterAnimIsPaused === false) {
//                console.log("Pausing")
                letterAnimIsPaused = true;
                var animInfo = setAnimInfoForMove();
                drawAnim.pause();
                setTimeout(function(){ pauseAnim();}, movePointAnim.duration);
            } else {
//                console.log("Resuming")
                letterAnimIsPaused = false;
                drawAnim.resume();
            }
        }

        onPaint: {
            var ctx = getContext("2d");
            ctx.beginPath();
            ctx.moveTo(moves[lastDrawnMoveIndex].x+drawingTools.xTranslate, moves[lastDrawnMoveIndex].y+ drawingTools.yTranslate);

            for(var moveIndex = lastDrawnMoveIndex+1; moveIndex <= currentAnimPoint; ++moveIndex){
                var move = moves[moveIndex];
                if(move.type === "move"){
                    lastDrawnMoveIndex = moveIndex;
                    pauseAnim();
                    break;
                }
                drawingTools.drawMove(move, ctx);
                lastDrawnMoveIndex = moveIndex;

                //console.log(moveIndex);
            }

            ctx.strokeStyle = "blue";
            //ctx.lineWidth = 8;
            ctx.stroke();
            ctx.closePath();
        }
    }

    Canvas
    {
        id:currentPointLayer;
        anchors.fill: parent;
        property int moveEndX: 0;
        property int moveEndY: 0;
        property int moveStartX: 0;
        property int moveStartY: 0;

        property real ellipseWidth : 20.;

        function drawInterpolatedPoint(ctx){
            var x = moveStartX + (moveEndX - moveStartX) * moveAnimPercentage /100. ;
            var y = moveStartY + (moveEndY - moveStartY) * moveAnimPercentage /100.;
            drawingTools.drawEllipse({"x":x,"y":y}, ellipseWidth/2., ctx);

            //ctx.ellipse(x-ellipseWidth/2. + drawingTools.xTranslate, y-ellipseWidth/2. + drawingTools.yTranslate, ellipseWidth,ellipseWidth);
        }
        function launchMoveAnimation(duration, endX, endY){
            moveEndX = endX;
            moveEndY = endY;
            movePointAnim.duration = duration;
            movePointAnim.start();
        }

        function drawCurrentPoint(ctx){
            if(currentAnimPoint == 0)
                return;
            ctx.beginPath();
            ctx.lineWidth = 2;
            if(movePointAnim.running){
                ctx.strokeStyle = "grey";
                drawInterpolatedPoint(ctx);
                ctx.stroke();
            } else {
                ctx.fillStyle = "green";
                var currentMove = moves[currentAnimPoint];
                ctx.ellipse(currentMove.x-ellipseWidth/2. + drawingTools.xTranslate,
                            currentMove.y-ellipseWidth/2. + drawingTools.yTranslate,
                            ellipseWidth,ellipseWidth);
                ctx.fill();
            }

           ctx.closePath();
        }
        onPaint: {

            var ctx = getContext("2d");
            ctx.reset();
            drawCurrentPoint(ctx);
        }
        function reset(){
            if(available){
                var ctx = getContext("2d");
                ctx.reset();
                requestPaint();
            }
        }
    }
}
