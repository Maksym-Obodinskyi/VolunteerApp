#define LOG_CATEGORY "MAIN"
#define LOG_LEVEL _TRACE_
#include "Logger.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QLocale>
#include <QTranslator>
#include <iostream>
#include <filesystem>

#include "RequestManager.h"
#include "RequestModel.h"
#include "SessionManager.h"
#include "RequestInfo.h"

namespace fs = std::filesystem;

int main(int argc, char *argv[])
{
    TRACE();
    SessionManager::declareInQML();
    RequestManager::declareInQML();
    RequestModel::declareInQML();
    RequestInfo::declareInQML();

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    QTranslator translator;
    const QStringList uiLanguages = QLocale::system().uiLanguages();
    for (const QString &locale : uiLanguages) {
      const QString baseName = "VolunteerApp_" + QLocale(locale).name();
      if (translator.load(":/i18n/" + baseName)) {
          app.installTranslator(&translator);
          break;
        }
    }

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                   &app, [url](QObject *obj, const QUrl &objUrl) {
    if (!obj && url == objUrl)
      QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
