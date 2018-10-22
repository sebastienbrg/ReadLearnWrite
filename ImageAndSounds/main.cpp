#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "imagesoundmodelmanager.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    ImageSoundModelManager manager;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("imageSoundsModel", manager.getModel());
    engine.rootContext()->setContextProperty("imageSoundsManager", &manager);
    engine.load(QUrl("./main.qml"));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
