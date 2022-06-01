#ifndef REQUESTMANAGER_H
#define REQUESTMANAGER_H

#include <QObject>
#include <QQmlEngine>

#include "RequestController.h"
#include "RequestModel.h"
#include "RequestView.h"

class RequestManager : public QObject
{
    Q_OBJECT
public:

    static void declareInQML();
    static QObject* singletoneProvider(QQmlEngine * engine, QJSEngine * scriptEngine);
    static RequestManager& instance();

    Q_INVOKABLE void getRequests();
    Q_INVOKABLE void addToFavorites();
    Q_INVOKABLE void editRequest();
    Q_INVOKABLE void addRequests();
    Q_INVOKABLE void getByFilter();
    Q_INVOKABLE void getFavoritesList();
    Q_INVOKABLE void getLastViewedList();
private:
    RequestManager();
    RequestManager(const RequestManager &) = delete;
    RequestManager(const RequestManager &&) = delete;
    RequestManager& operator=(const RequestManager &) = delete;
    RequestManager& operator=(const RequestManager &&) = delete;

    RequestController   _contr;
};

#endif // REQUESTMANAGER_H
