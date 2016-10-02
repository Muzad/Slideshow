TEMPLATE = app

QT += qml quick

CONFIG += c++11

SOURCES += main.cpp

TARGET = Slideshow

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS +=

android {
    QT += androidextras
}

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

DISTFILES += \
    android/AndroidManifest.xml \
    android/src/ir/cvas/slideshow/AndroidUtility.java \
    android/res/values/libs.xml \
    android/build.gradle
