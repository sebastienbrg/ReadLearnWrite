import QtQuick 2.0

Item {
    anchors.fill: parent
    Rectangle{
        id:sky
        anchors.fill: parent
        color: "#00E5FF"
    }

    Rectangle{
        id: sun
        width: 100
        height: 100
        radius: width/2
        x: 400
        y: 150
        color:"yellow"
    }
    PropertyAnimation{
        id:movingCloud1
        target: cloud1
        properties: "x"
        duration: 60000
        from:-10 - cloud1.width
        to:root.width
        loops: Animation.Infinite
    }
    Image {
        id: cloud1
        source: "img/nuage.png"
        y:100
        opacity: 0.9
    }
    PropertyAnimation{
        id:movingCloud2
        target: cloud2
        properties: "x"
        duration: 45000
        from:-10 - cloud2.width
        to:root.width
        loops: Animation.Infinite
    }
    Image {
        id: cloud2
        source: "img/nuage.png"
        y:250
        opacity: 0.9
    }

    Component.onCompleted: {
        movingCloud1.restart();
        movingCloud2.restart();
    }
    onWidthChanged: {
        movingCloud1.to = root.width;
        movingCloud2.to = root.width;
        movingCloud1.restart()
        movingCloud2.restart()
    }

}
