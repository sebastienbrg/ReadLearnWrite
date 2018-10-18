import QtQuick 2.9
import QtQuick.Window 2.2

Window {
    id:root
    visible: true
    width: 640 *2
    height: 480 *2
    property int toolsHeight: 100
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
    LetterEditor
    {
        id: letterEditor
    }
    Component.onCompleted : {
        letterManager.letter = "a";
    }
}
