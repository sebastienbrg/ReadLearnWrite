#ifndef PATHMODEL_H
#define PATHMODEL_H

#include <QObject>
#include <QMap>
#include <QPainterPath>
#include "lettermodels_global.h"

class LETTERMODELSSHARED_EXPORT PathElement {
public:
    enum MoveType{
        Move = 0,
        Line,
        Curve
    };
    PathElement(QString moveStr);
    QString toJsonString() const;
    void toPainterPath(QPainterPath& painterPath) const;
    MoveType type() const;

private:
    MoveType mType;
    int x;
    int y;
    int ctrX;
    int ctrY;
};

class LETTERMODELSSHARED_EXPORT Path {
public:
    Path() {}
    Path(QString serialized);
    QString toJsonString() const;
    QPainterPath toPainterPath();
    QList<QList<QPointF> > subdivide();
private:
    QList<PathElement> mElements;
};

class LETTERMODELSSHARED_EXPORT PathModel : public QObject
{
    Q_OBJECT
public:
    explicit PathModel(QObject *parent = nullptr);
    Q_INVOKABLE void setPathForLetter(const QString& letter, const QString& path);
    Q_INVOKABLE QString getPathForLetter(const QString& letter);
signals:

public slots:
private:
    QString getSubdivePathAsJSON(const QString& letter);
    QMap<QString, Path> mLetterPaths;
    QMap<QString, QString> mSubPathsMap;
};

#endif // PATHMODEL_H
