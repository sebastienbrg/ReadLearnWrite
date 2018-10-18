import QtQuick 2.0
import QtQuick.Controls 2.2

Item {
    id: root;
    width: parent.width;
    height: toolsHeight
    property ListModel buttonModel
    signal btnClicked(string btnName);
    property int borderW: 2
    function setCurrentIndex(currentIndex){
        for(var i = 0; i < buttonModel.count; ++i){
                buttonModel.setProperty(i, "isCurrent", (i === currentIndex));
        }
    }

    ListView{
        id:theList
        anchors.fill: parent
        model : root.buttonModel
        orientation: Qt.Horizontal
        currentIndex: 2
        delegate :
            Item{
                height: toolsHeight
                width: height

                Image {
                    id: icon
                    source: (imgSrc !== undefined)?imgSrc:""
                    visible: (imgSrc !== undefined && (imgSrc.length > 0))
                    height: toolsHeight - 2*borderW
                    y:borderW
                    x:borderW
                    fillMode: Image.PreserveAspectFit
                }
                Rectangle{
                    id:hoverCicle
                    height: toolsHeight
                    width: height
                    radius: toolsHeight/2
                    color: "transparent"
                    opacity: 0.25
                    Text {
                        anchors.fill : parent
                        text: text
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        visible : !icon.visible
                    }
                }
                Rectangle{
                    height: toolsHeight
                    width: height
                    radius: toolsHeight/2
                    color: "transparent"
                    border.color: "black"
                    border.width:(model.isCurrent === undefined || model.isCurrent === false) ? 0 : (3 * borderW)
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        root.btnClicked(text);
                    }
                    hoverEnabled: true
                    onEntered: {
                        console.log(model.text, model.isCurrent)
                        hoverCicle.color = "yellow";
                    }
                    onExited: hoverCicle.color = "transparent"
                }
                property bool validated : ((model.validated === undefined) ? false : model.validated);
                Validable{
                }

        }
    }

}
