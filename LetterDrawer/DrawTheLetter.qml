import QtQuick 2.0

Item {
    id:root
    property var moves;
    property var smoothMoves;
    property int lastOkPointIndex: 0
    property var pointList : []
    anchors.fill: parent;
    property int ellipseRadius: 5
    property int distance: -1
    property real factor: 0
    signal letterCorrectlyWritten()

    function getPointsDist(toMove, fromMove){
        var dist = Math.sqrt( Math.pow((toMove.x - fromMove.x),2) +  Math.pow((toMove.y - fromMove.y),2));
        return dist
    }
    function getDistanceToNextPoint(mouseX, mouseY){
        var nextPoint = pointList[lastOkPointIndex+1];
        if(nextPoint){
            return getPointsDist({"x":(mouseX - drawingTools.xTranslate), "y":(mouseY - drawingTools.yTranslate)}, nextPoint);

        }
        return -1;
    }
    function getDistanceToPreviousPoint(mouseX, mouseY){
        var previousPoint = pointList[lastOkPointIndex];
        if(previousPoint){
            return getPointsDist({"x":(mouseX - drawingTools.xTranslate), "y":(mouseY - drawingTools.yTranslate)}, previousPoint);

        }
        return -1;
    }
    function computeFactor(){
        var factorTmp = root.distance / ellipseRadius *2.;
        factorTmp -= 2;
        factorTmp = Math.max(0,factorTmp);
        factorTmp = Math.min(10, factorTmp);
        factor = factorTmp;
    }

    onMovesChanged: {
        root.pointList = [];
        if(moves.length <= 0)
            return;
        var baseMove = moves[0];
        moves.forEach(function(move, index){
            if(index > 0){
                var dist = getPointsDist(baseMove, move);
                if(dist > 2.5*ellipseRadius){
                    root.pointList.push(move);
                    baseMove = move;
                }
            }
        });
    }
    onLastOkPointIndexChanged: {
        if(lastOkPointIndex == (pointList.length -1)){
            console.log("Done !")
            lastOkPointIndex = 0
            letterCorrectlyWritten();
        }

        upperLayer.reset();
        upperLayer.requestPaint();
    }

    function repaint(){
        lowerLayer.reset();
        lowerLayer.requestPaint();
        upperLayer.reset();
        upperLayer.requestPaint();
    }

    Canvas {
        id: lowerLayer
        anchors.fill: parent;
        function reset(){
            if(!available)
                return;
            var ctx = getContext("2d");
            ctx.reset();
        }

        onPaint: {
            var ctx = getContext("2d");
            smoothMoves.forEach(function(move){
                drawingTools.drawMove(move, ctx);
            });
            ctx.lineWidth = 12;
            ctx.strokeStyle = "#DDDDFF";
            ctx.stroke();
        }
    }
    Canvas {
        id: upperLayer
        anchors.fill: parent;
        function reset(){
            if(!available)
                return;
            var ctx = getContext("2d");
            ctx.reset();
        }

        onPaint: {
            var ctx = getContext("2d");
            ctx.beginPath();
            root.pointList.forEach(function (move, index){
                if(index > lastOkPointIndex){
                    drawingTools.drawEllipse(move, ellipseRadius, ctx);
                    if(index === (lastOkPointIndex+1)){
                        ctx.strokeStyle = "green";
                        ctx.lineWidth = 3;
                        ctx.stroke();
                        ctx.closePath();
                        ctx.beginPath();
                    }
                }
            });

            ctx.lineWidth = 1;
            ctx.strokeStyle = "black";
            ctx.stroke();
        }
        MouseArea{
            anchors.fill:parent;
            onPositionChanged: {
                //console.log("Mouse pos ", mouseX, mouseY);
                var nextPointDist = root.getDistanceToNextPoint(mouseX, mouseY);
                if(nextPointDist > -1 && nextPointDist < 10){
                    root.lastOkPointIndex++;
                }
                var previousPointDist = root.getDistanceToPreviousPoint(mouseX, mouseY);
                root.distance = Math.min(previousPointDist, nextPointDist);
                root.computeFactor();
                if(root.factor == 10){
                    root.lastOkPointIndex = 0;
                }

            }
        }
    }
    DistanceDisplay {
        id:display
        distance: root.distance
        anchors.left: root.left
        anchors.top: root.verticalCenter
        height: 100
        width: 100
        factor: root.factor
    }
}
