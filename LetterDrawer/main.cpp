#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "pathmodel.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<PathModel>("pathmodel", 1, 0, "PathModel");

    engine.load(QUrl("./main.qml"));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
