#include "pathmodel.h"
#include <QDebug>
#include <QRegularExpression>
#include <QtMath>
#include <QFile>

PathModel::PathModel(QObject *parent) : QObject(parent)
{

}

void PathModel::setPathForLetter(const QString &letter, const QString &path)
{
    qDebug() << "Storing path for letter " << letter << " : " << path;
    mLetterPaths[letter] = Path(path);
    QFile f(QString("../LetterDrawer/letters/%1.json").arg(letter));
    if(f.open(QIODevice::WriteOnly)){
        QString subDivPath = getSubdivePathAsJSON(letter);
        QString totalString = QString("{\"smooth\":%1, \"byPoints\":%2}").arg(path).arg(subDivPath);
        mSubPathsMap[letter] = totalString;
        f.write(totalString.toLatin1());
        f.close();
    }

}

QString PathModel::getPathForLetter(const QString &letter)
{
    qDebug() << "Looking for a path for letter " << letter;
    if(mSubPathsMap.contains(letter)){
        return mSubPathsMap[letter];
    } else {
        QFile f(QString("../LetterDrawer/letters/%1.json").arg(letter));
        if(f.exists()){
            qDebug() << "Loading file";
            QString content;
            if(f.open(QIODevice::ReadOnly)){
                content = QString(f.readAll());
            }
            //qDebug() << content;
            mSubPathsMap[letter] = content;
            return content;
        }
        return QString("{\"smooth\":[], \"byPoints\":[]}");
    }
}

QString PathModel::getSubdivePathAsJSON(const QString &letter)
{
    if(mLetterPaths.contains(letter)){
        QList<QList<QPointF>> pointsList = mLetterPaths[letter].subdivide();
        QString jsonStr = "[";
        qDebug() << " Serializing a array of " << pointsList.size() << " array of points";
        bool veryFirst = true;
        for(const QList<QPointF>& points : pointsList){
            int pointIndex = 0;
            for(const QPointF& point : points){
                if(pointIndex == 0){
                    jsonStr.append(QString("%3{\"type\":\"move\",\"x\":%1,\"y\":%2}")
                            .arg((int)point.x())
                            .arg((int)point.y())
                                   .arg(veryFirst?"":","));
                } else {
                    jsonStr.append(QString(",{\"type\":\"line\",\"x\":%1,\"y\":%2}")
                            .arg((int)point.x())
                            .arg((int)point.y()));
                }
                veryFirst = false;
                ++ pointIndex;
            }
        }
        jsonStr += "]";
        return jsonStr;
    }
    return QString();
}



Path::Path(QString serialized)
{
    serialized = serialized.mid(2, serialized.length()-4);
    QStringList serializedElements = serialized.split("},{");
    for(const QString& move : serializedElements){
        mElements << PathElement(move);
    }
}

QString Path::toJsonString() const
{
    QString json = "[";
    for(const PathElement& elt: mElements){
        json += elt.toJsonString();
        json += ",";
    }
    if(json.length() > 0){
        json = json.left(json.length() -1);
    }
    json.append("]");
    return json;
}

qreal distTo(QPointF p1, QPointF p2){
    return qSqrt(qPow(p1.x() -p2.x(),2) +  qPow(p1.y() -p2.y(),2));
}
QList<QPointF> pathToPoints(const QPainterPath& path){
    QList<QPointF> points;
    for(int percentage = 0; percentage <= 1000; ++percentage){
        QPointF point =path.pointAtPercent(percentage / 1000.);
        if(percentage == 0 || distTo(points.last(), point) > 1.)
            points << point;
    }
    return points;
}

QList<QList<QPointF>> Path::subdivide()
{
    QList<QList<QPointF>> pointsList;
    QPainterPath path;
    for(const PathElement& elt: mElements){
        if(elt.type() == PathElement::Move){
            if(!path.isEmpty()){
                QList<QPointF> points = pathToPoints(path);
                pointsList << points;
                path = QPainterPath();
            }
        }
        elt.toPainterPath(path);
    }
    if(!path.isEmpty()){
        QList<QPointF> points = pathToPoints(path);
        pointsList << points;
    }

    qDebug() << "points : " << pointsList.length();
    return pointsList;
}

QString getKeyValue(const QString& key, const QString& serialized){
    QString patern = QString("\"%1\":\"?(\\w+)\"?\\b").arg(key);
    QRegularExpression reg(patern);
    QRegularExpressionMatch match= reg.match(serialized);
    if(match.hasMatch()){
        return match.captured(1);
    } else {
    }
    return QString();
}
QHash<QString, PathElement::MoveType> MoveNameMap {
    {"move", PathElement::Move},
    {"curve", PathElement::Curve},
    {"line", PathElement::Line}
};


PathElement::PathElement(QString moveStr)
{
    QString type = getKeyValue("type", moveStr);
    x = getKeyValue("x", moveStr).toInt();
    y = getKeyValue("y", moveStr).toInt();
    mType = MoveNameMap[type];
    if(mType == Curve){
        ctrX = getKeyValue("ctrX", moveStr).toInt();
        ctrY = getKeyValue("ctrY", moveStr).toInt();
    }
    //{\"type\":\"move\",\"x\":202,\"y\":108}
}

QString PathElement::toJsonString() const
{
    return "{\"type\":\"move\",\"x\":202,\"y\":108}";
}

void PathElement::toPainterPath(QPainterPath &painterPath) const
{
    switch (mType) {
    case Move:
        painterPath.moveTo(x,y);
        break;
    case Curve:
        painterPath.quadTo(ctrX, ctrY, x, y);
        break;
    case Line:
        painterPath.lineTo(x,y);
    default:
        break;
    }
}

PathElement::MoveType PathElement::type() const
{
    return mType;
}
