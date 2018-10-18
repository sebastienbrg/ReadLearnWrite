import QtQuick 2.0
Item {
    id:root
    property int  xTranslate : letterManager.xTranslate;
    property int  yTranslate : letterManager.yTranslate;
    function drawMove(move, ctx){
        switch(move.type){
        case "move":
            ctx.moveTo(move.x+xTranslate, move.y+yTranslate);
            break;
        case "line":
            ctx.lineTo(move.x+xTranslate, move.y+yTranslate);
            break;
        case "curve":
            ctx.quadraticCurveTo(move.ctrX+xTranslate,
                                 move.ctrY+yTranslate,
                                 move.x+xTranslate,
                                 move.y+yTranslate)
            break;
        }
    }
    function drawEllipse(move, radius, ctx){
        ctx.ellipse(move.x - radius + xTranslate,
                    move.y - radius + yTranslate,
                    2 * radius,
                    2 * radius);
    }

    function createPath(context, points){
        for (var i = 0; i < points.length - 2; i ++)
           {
              var xc = (points[i].x + points[i + 1].x) / 2;
              var yc = (points[i].y + points[i + 1].y) / 2;
              context.quadraticCurveTo(points[i].x, points[i].y, xc, yc);
           }
         // curve through the last two points
         context.quadraticCurveTo(points[points.length - 2].x,
                                  points[points.length - 2].y,
                                  points[points.length - 1].x,
                                  points[points.length - 1].y);

    }
}

