import QtQuick 2.9


Item {
    id: root
    property string letter : letterManager.letter
    property string moveType: toolBox.moveType
    property var moves : letterManager.moves
    property var curvePoint : ({})
    property double currentX: 0
    property double currentY: 0

    width: parent.width
    height: parent.height - toolsHeight
    y:toolsHeight
    x:0

    function reset(){
        mainCanevas.reset()
    }


    function getCurrentPath(){
        console.log("returning current path");
        return JSON.stringify(moves);
    }
    onMovesChanged: {
        mainCanevas.reset();
    }

    onMoveTypeChanged: {
        console.log("Move is now ", moveType)
        if(moveType == "curve"){
            curvePoint = {
                targetX: undefined,
                targetY: undefined
            }
        };
    }    

    Canvas
    {
        id: mainCanevas
        anchors.fill: parent;

        function reset(){
            if(available){
                var ctx = getContext("2d");
                ctx.reset();
                if(ctx){
                    requestPaint();
                }
                console.log("Reset")
            }
        }

        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            ctx.font = "500px 'Pere Castor'";
            ctx.fillStyle = "red"
            ctx.textBaseline = "middle";
            var widthOjb = ctx.measureText(root.letter);
            ctx.strokeStyle = "red"
            ctx.globalCompositeOperation = "source-over"
            ctx.fillText(root.letter, (parent.width - widthOjb.width) /2. , (parent.height) / 2.);

            ctx.strokeStyle = "blue"
            ctx.beginPath();
            root.moves.forEach(function(move){
                drawingTools.drawMove(move, ctx);
            });
            if(root.moveType == "line"){
                ctx.lineTo(currentX, currentY);
            } else if(root.moveType == "move"){
                ctx.ellipse(currentX, currentY, 2,2);
            } else if(root.moveType == "curve"){
                if(root.curvePoint.targetX === undefined){
                    ctx.lineTo(currentX, currentY);
                } else {
                    ctx.quadraticCurveTo( currentX,
                                         currentY,
                                         root.curvePoint.targetX,
                                         root.curvePoint.targetY);
                }
            }
            ctx.stroke();
        }
        function addMove(move){
            move.x -= drawingTools.xTranslate;
            move.y -= drawingTools.yTranslate;
            if(move.ctrX)
                move.ctrX -= drawingTools.xTranslate;
            if(move.ctrY)
                move.ctrY -= drawingTools.xTranslate;
            root.moves.push(move);
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled : true
            onReleased: {
                if(root.moveType == "move" || root.moves.length == 0){
                    var moveLength = root.moves.length;
                    if(moveLength > 0 && root.moves[moveLength -1 ].type === "move"){
                        root.moves[moveLength-1] = {type:"move", x:mouseX - drawingTools.xTranslate, y:mouseY-drawingTools.yTranslate}
                    } else {
                        mainCanevas.addMove({type:"move", x:mouseX, y:mouseY});
                    }
                } else if(root.moveType == "curve"){
                    if(root.curvePoint.targetX === undefined){
                        root.curvePoint.targetX = mouseX;
                        root.curvePoint.targetY = mouseY;
                    } else {
                        mainCanevas.addMove( {type:"curve", x:root.curvePoint.targetX, y:root.curvePoint.targetY, ctrX:mouseX, ctrY:mouseY});
                        root.curvePoint = {};
                    }
                } else {
                    mainCanevas.addMove({type:root.moveType, x:mouseX, y:mouseY})
                }
                mainCanevas.requestPaint();
                focus = true;
            }
            focus: true;
            Keys.onPressed: {
                if(event.key === Qt.Key_Escape){
                    if(root.moveType == "curve" && root.curvePoint.targetX !== undefined){
                        root.curvePoint = {};
                        console.log("losing curve target point");
                        mainCanevas.requestPaint();
                    } else {
                        if(root.moves.length > 0){
                            root.moves.splice(root.moves.length-1, 1);
                            console.log("losing last move");
                            mainCanevas.requestPaint();
                        }
                    }
                }

                console.log("pressed :", event.key)
            }
            onPositionChanged: {
                currentX = mouseX;
                currentY = mouseY;
                mainCanevas.requestPaint();
            }
        }
    }
    ToolBox{
        id:toolBox
    }
}
