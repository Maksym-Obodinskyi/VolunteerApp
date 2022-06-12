#ifndef REQUESTMANAGER_H
#define REQUESTMANAGER_H

#include <QObject>
#include <QQmlEngine>

#include "RequestController.h"
#include "RequestModel.h"

class RequestManager : public QObject
{
    Q_OBJECT
public:
    static void declareInQML();
    static QObject* singletoneProvider(QQmlEngine * engine, QJSEngine * scriptEngine);
    static RequestManager& instance();

    Q_INVOKABLE void getRequests();
    Q_INVOKABLE void addToFavorites(double latitude
                                    , double longitude
                                    , QString title
                                    , QString description
                                    , int date);
    Q_INVOKABLE void editRequest();
    Q_INVOKABLE void addRequest(double latitude
                                , double longitude
                                , QString title
                                , QString description
                                , QString categories
                                , int date);
    Q_INVOKABLE void getByFilter(const std::set<const std::string &> & categories);
    Q_INVOKABLE void getFavoritesList();
    Q_INVOKABLE void getLastViewedList();
    Q_INVOKABLE void getUsersRequests();

private:
    RequestManager(RequestController & contr = RequestController::instance());
    RequestManager(const RequestManager &) = delete;
    RequestManager(const RequestManager &&) = delete;
    RequestManager& operator=(const RequestManager &) = delete;
    RequestManager& operator=(const RequestManager &&) = delete;

    RequestController & _contr;
};

#endif // REQUESTMANAGER_H
