import QtQuick 2.0

Item {
    id:root
    property int xWhenHidden
    property int xWhenShown : 0
    property bool shown: true

    signal enterAnimDone()

    function updateAllPositions(){
        if(moveIn.running){
            console.log("width changed, moveIn to => ", xWhenShown)
            moveIn.to = xWhenShown;
        } else if(moveOut.running){
            console.log("width changed, moveOut to => ", xWhenHidden)
            moveOut.to = xWhenHidden
        } else {
            if(shown){
                console.log("width changed x = xWhenShown =", xWhenShown);
                x = xWhenShown
            } else {
                console.log("width changed x = xWhenHidden = ", xWhenHidden, parent.width);
                x = xWhenHidden
            }
        }
    }
    onXWhenShownChanged: {
        updateAllPositions();
    }

    onXWhenHiddenChanged: {
        updateAllPositions();
    }

    PropertyAnimation{
        id:moveIn
        target: root
        properties: "x"
        duration: 1000
        from:xWhenHidden
        to: xWhenShown
        onStopped: root.enterAnimDone();
        easing.type: Easing.InOutQuad
    }
    PropertyAnimation{
        id:moveOut
        target: root
        properties: "x"
        duration: 1000
        from:xWhenShown
        to: xWhenHidden
        easing.type: Easing.InOutQuad
    }
    function moveInOrOut(appear){
        if(appear){
            shown = true;
            console.log("Moving in to ", moveIn.to)
            moveIn.start()
        } else {
            shown = false;
            console.log("Moving out to ", moveOut.to)
            moveOut.start()
        }
    }
}
