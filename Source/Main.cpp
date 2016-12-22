#include <QtGui>
#include <QtQuick>
#include "Settings.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQuickView* view = new QQuickView();

    view->setTitle("Color Rain");
    view->setColor(Qt::white);

    #if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
        view->setWidth(app.primaryScreen()->size().width());
        view->setHeight(app.primaryScreen()->size().height());
    #else
        view->setWidth(250);
        view->setHeight(400);
    #endif

    // Создаём объекты QML
    const double mmInInch = 25.4;
    double _mm = app.screens().first()->physicalDotsPerInch()/mmInInch;

    view->rootContext()->setContextProperty("mm", _mm);
    view->rootContext()->setContextProperty("Window", view);
    view->rootContext()->setContextProperty("Settings", &Settings::instance());
    view->setSource(QUrl("qrc:/Root.qml"));
    view->show();

    return app.exec();
}
