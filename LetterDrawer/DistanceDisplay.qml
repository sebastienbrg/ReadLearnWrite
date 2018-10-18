import QtQuick 2.0

Item {
    id:root;
    property int distance: 0
    property real factor
    onDistanceChanged: {
        if(distance == -1)
            return;
        mouth.distanceChanged();
    }

    Rectangle{

        id: face;
        radius: width/2.;
        anchors.fill: parent;
        color: "yellow"
        Rectangle {
            id: leftEye;
            radius: width/2.
            width : face.width /6.
            height: width
            color: "black"
            y: face.width /4.
            x: face.width /4. - width / 2.
        }
        Rectangle {
            id: rightEye
            radius: width/2.
            width : face.width /6.
            height: width
            color: "black"
            y: face.width /4.
            x: face.width * 3./4. - width / 2.
        }
        Canvas {
            id:mouth
            contextType: "2d"
            property int ellipseRadius: 5
            anchors.fill: parent;
            function getMiddleY(factor){
                var maxY = face.width - ellipseRadius;
                var minY = face.width /2 + ellipseRadius;
                var pos = maxY - ((maxY - minY) * factor / 10) -5;
                return pos;
            }

            Path{
                id:mouthPath;
                startX: face.width /6.;
                startY: 3* face.width /4. -5;
                PathCurve { id:midPathPoint1; x: 2*face.width /6.+5; y :  3* face.width /4.}
                PathCurve { id:midPathPoint2; x: 4*face.width /6.-5; y :  3* face.width /4.}

                PathCurve { x: 5*face.width /6.; y : 3* face.width /4. -5}
            }

            onPaint: {
                context.strokeStyle = "black";
                context.lineWidth = 5;
                context.path = mouthPath;
                context.stroke();
            }
            function distanceChanged() {
                context.reset();
                if(distance == -1){
                    face.color = "yellow";
                    midPathPoint1.y = getMiddleY(5);
                    midPathPoint2.y = getMiddleY(5);
                } else {

                    if(factor == 10){
                        return;
                    }

                    midPathPoint1.y = getMiddleY(factor);
                    midPathPoint2.y = getMiddleY(factor);
                    var red = factor >= 5. ? 1. : factor  / 5.;
                    var green = factor <= 5. ? 1. : 1- (factor-5.)/5.;
                    face.color = Qt.rgba(red, green, 0, 1);

                }

                requestPaint();
            }
        }
    }
}
