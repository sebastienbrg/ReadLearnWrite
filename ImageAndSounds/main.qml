import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.0

Window {
    id:root;
    visible: true
    width: 640*2
    height: 480*2
    Rectangle{
        id: tools;
        width: parent.width;
        height: 100;
        border.color: "black";
        border.width: 2;
        Item{
            anchors.fill:parent
            anchors.margins: 5
            Column{
                id: formCol

                Row{
                    spacing: 3
                    Text{
                        text: "Image url:"
                    }
                    TextInput{
                        id: imgUrl
                        width: 200
                    }
                }
                Row{
                    spacing: 3
                    Text{
                        text: "Image name:"
                    }
                    TextEdit{
                        id: imgName
                        width: 200
                        text: "NewName"
                    }
                }
                Row{
                    spacing: 3
                    Text{
                        text: "Sounds:"
                    }
                    TextEdit{
                        id: sounds
                        width: 200
                        text: ""
                    }
                }

            }
        }
    }
    ListView{
        anchors.fill: parent;
        anchors.leftMargin: imgRect.width
        anchors.topMargin: tools.height

        model: imageSoundsModel;
        delegate:  ImageSoundsEntry{
            name : model.name
            index : model.index
        }
    }

    Row{
        anchors.bottom: tools.bottom
        anchors.left : tools.left
        anchors.margins: 5
        Button{
            id: loadImg
            text: "Load img"
            onClicked: {
                image.source = imgUrl.text;
            }
        }
        Button{
            id: saveImg
            text: "Save img"
            onClicked: {
//                image.grabToImage(function(result) {
//                                           result.saveToFile("../LetterDrawer/img/gameImg/" +imgName.text+".png");
//                                       });
                imageSoundsManager.addImageSoundToModel(imgName.text);
            }
        }
    }

    Rectangle{
        id: imgRect
        color:"lightgrey"
        anchors.fill: parent
        anchors.topMargin: tools.height
        anchors.rightMargin: 0.2*root.width

        Image{
            id: image
            anchors.fill: parent
            height: parent.height - tools.height
            fillMode: Image.PreserveAspectFit
            source: "../LetterDrawer/img/arbre.png"
        }
    }

}
