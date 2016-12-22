TEMPLATE = app

QT += qml quick
CONFIG += c++11

include(Deployment.pri)

INCLUDEPATH += Include
HEADERS += \
    Include/Settings.h

SOURCES += \
    Source/Main.cpp \
    Source/Settings.cpp

RESOURCES += \
    $$PWD/Qml/Qml.qrc \
    $$PWD/Audio/Audio.qrc

android {
    QT += androidextras

    DISTFILES += \
        Android/AndroidManifest.xml \
        Android/gradle/wrapper/gradle-wrapper.jar \
        Android/gradlew \
        Android/res/values/libs.xml \
        Android/build.gradle \
        Android/gradle/wrapper/gradle-wrapper.properties \
        Android/gradlew.bat \
        Android/src/com/sp/colorrain/ColorRainActivity.java

    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/Android
}
