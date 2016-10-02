#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QStandardPaths>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // JUST FOR QT 5.7 BUG IN ANDROID 5,SUPER STRANGE!!(Crash message after cloasing app)
    engine.setOfflineStoragePath( QStandardPaths::standardLocations( QStandardPaths::DocumentsLocation )[0] );

    QString path = QStandardPaths::standardLocations( QStandardPaths::PicturesLocation ).value(0);
    engine.rootContext()->setContextProperty("PicDir", path);

    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    return app.exec();
}
