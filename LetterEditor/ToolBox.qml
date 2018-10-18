import QtQuick 2.9
import QtQuick.Controls 2.2

Item {
    id:root
    property alias currentLetter : chosenLetter.text
    property string moveType: "none"
    signal saveClicked();
    signal razClicked();
    signal playClicked();
    anchors.fill: parent
    onSaveClicked: {
        letterManager.savePath();
    }
    onRazClicked: {
        letterManager.moves = [];
    }
    onPlayClicked: {
        letterGame.play();
    }

    function updateMoveType(newMove, active)
    {
        if(active){
            moveType = newMove
        } else {
          moveType = "none"
        }
    }
    ButtonGroup {
        buttons: buttonRow.children
    }

    Row {
        id:buttonRow
        anchors.fill: parent
        anchors.margins: 5
        layoutDirection: Qt.RightToLeft
        RoundButton
        {
            id:useLines
            height: toolsHeight
            width: toolsHeight
            checkable: true
            text:"lines"
            onClicked: root.updateMoveType("line", checked)
        }
        RoundButton
        {
            id:useCurves
            height: toolsHeight
            width: toolsHeight
            checkable: true
            text:"curves"
            onClicked: root.updateMoveType("curve", checked)
        }
        RoundButton
        {
            id:useMove
            height: toolsHeight
            width: toolsHeight
            checkable: true
            text:"move"
            onClicked: root.updateMoveType("move", checked)
        }
        RoundButton
        {
            id:save
            height: toolsHeight
            width: toolsHeight
            checkable: true
            text:"save"
            onClicked: root.saveClicked();
        }
        RoundButton
        {
            id:raz
            height: toolsHeight
            width: toolsHeight
            checkable: true
            text:"RAZ"
            onClicked: root.razClicked();
            visible: (root.displayType=="Edit")
        }
    }
    TextEdit{
        id:chosenLetter
        anchors.left: parent.left
        width: toolsHeight
        height: toolsHeight
        text: "a"
        font.pointSize:60
        onTextChanged: letterManager.letter = text;
    }
}
