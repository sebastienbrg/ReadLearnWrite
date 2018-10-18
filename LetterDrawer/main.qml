import QtQuick 2.9
import QtQuick.Window 2.2

Window {
    id: root
    visible: true
    width: 640*2
    height: 480*2
    title: qsTr("Letter drawer")
    property int toolsHeight: 100

    BackGround{

    }

    CurrentLetterManager{
        id: letterManager
        windowWidth: root.width
        windowHeight: root.height
    }
    DrawFunctions{
        id:drawingTools
    }

    onWidthChanged: {
       letterManager.updateXTranslate();
    }
    onHeightChanged: {
        letterManager.updateYTranslate();
    }

    LetterGame{
        id:letterGame
        shown: false
        onGoBackToMenu: {
            carroussel.moveInOrOut(true);
            letterGame.moveInOrOut(false);
        }
    }
    LetterCarroussel{
        id:carroussel
        onLetterSelected: function(letter){
            letterManager.letter = letter;
            carroussel.moveInOrOut(false);
            letterGame.reset();
            letterGame.moveInOrOut(true);
        }
    }

    Component.onCompleted : {
        letterManager.letter = "a";
    }
}
