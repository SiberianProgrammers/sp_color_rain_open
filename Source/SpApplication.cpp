#include <QDebug>
#include "SpApplication.h"

#ifdef Q_OS_ANDROID
#include <QAndroidJniObject>
#include <QAndroidJniEnvironment>
#endif

sp::SpApplication::SpApplication(int &argc, char **argv, const QString &title, int width, int height)
    : SpApplicationPrototype (argc, argv, title, width, height)
{
    //  этом месте происходит регистрация классов
    //qmlRegisterType<sp::XaocModel>("SP", 1, 0, "XaocModel");

    #ifdef Q_OS_ANDROID
    QObject::connect(view(), SIGNAL(afterRendering()), this, SLOT(closeSplashScreen()));
    #endif
}

void sp::SpApplication::closeSplashScreen()
{
    #ifdef Q_OS_ANDROID
    if (firstRendering) {
        firstRendering = false;
        QAndroidJniObject activity = QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative",
                                                                               "activity", "()Landroid/app/Activity;");
        activity.callMethod<void>("finishSplash","()V");
    }
    #endif
}
