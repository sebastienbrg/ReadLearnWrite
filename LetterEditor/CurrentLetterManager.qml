import QtQuick 2.0
import pathmodel 1.0
Item {
    id: root
    property string letter
    property var moves : []
    property var smoothMoves : []
    property var boundingBox: ({})
    property int xTranslate: 0
    property int yTranslate: 0
    property int windowWidth
    property int windowHeight


    function updateYTranslate(){
        if(moves.length < 2)
            root.yTranslate = 0;
        else {
            var boxH = root.boundingBox.maxY  - root.boundingBox.minY;
            var boxNormalY = (windowHeight - boxH) /2.;
            root.yTranslate = boxNormalY - root.boundingBox.minY;
        }
        console.log("new deltaY : ", yTranslate);
    }
    function updateXTranslate(){
        if(moves.length < 2)
            root.xTranslate = 0;
        else {
            var boxW = root.boundingBox.maxX  - root.boundingBox.minX;
            var boxNormalX = (windowWidth - boxW) /2.;
            root.xTranslate = boxNormalX - root.boundingBox.minX;
        }
        console.log("new deltaX : ", xTranslate);
    }
    onLetterChanged: {
        console.log("new letter : ", root.letter);
        var serialized = model.getPathForLetter(root.letter);
        var moveList = JSON.parse(serialized);
        if(moveList.byPoints.length > 1){
            boundingBox = getBoundingBox(moveList.byPoints);
//            console.log("Box : ", JSON.stringify(boundingBox, null, 4));
        }
        smoothMoves = moveList.smooth;
        moves = moveList.byPoints;
        letterEditor.reset();
        updateXTranslate();
        updateYTranslate();
    }

    PathModel{
        id: model
    }
    function loadSubdividedPath(jsonStr){
//        console.log(jsonStr);
        moves = JSON.parse(jsonStr);
    }

    function getBoundingBox(moveList){
        var box = {"minX":999999, "maxX":0, "minY":99999, "maxY": 0};
        moveList.forEach(function(move){
            box.minX = Math.min(move.x, box.minX);
            box.minY = Math.min(move.y, box.minY);
            box.maxX = Math.max(move.x, box.maxX);
            box.maxY = Math.max(move.y, box.maxY);
        });
        return box;
    }
    function savePath(){
        model.setPathForLetter(letter, letterEditor.getCurrentPath())
        moves = model.getPathForLetter(letter);
    }
}
