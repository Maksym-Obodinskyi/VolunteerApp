#define LOG_CATEGORY "RequestManager"
#define LOG_LEVEL _TRACE_
#include "Logger.h"

#include <QQmlEngine>
#include <iostream>

#include "RequestManager.h"

RequestManager::RequestManager(RequestController & contr) : _contr(contr)
{
    TRACE();
}

QVariantList RequestManager::getRequests()
{
    TRACE();
    QVariantList list;
    Request req {
          {49.84004810606953, 24.02204252906137}
        , "Some short description"
        , "Very short title"
        , {"Category 1", "Category 2"}
        , 8
    };
    _contr.cleanData();
    _contr.getRequests();
    list << QVariant::fromValue(req);
    return list;
}

void RequestManager::addToFavorites(double longtitude
                                    , double latitude
                                    , QString title
                                    , QString description
                                    , int date)
{
    TRACE();
    _contr.cleanData();
    _contr.addToFavorites(Request(std::make_pair(longtitude, latitude), title.toStdString(), description.toStdString(), {}, date)
                          , User());
}

void RequestManager::editRequest()
{
    TRACE();
    _contr.cleanData();
    _contr.editRequest();
}

void RequestManager::addRequest([[maybe_unused]]const Request & request)
{
    TRACE();
    _contr.cleanData();
    _contr.addRequests();
}

void RequestManager::getByFilter([[maybe_unused]]const std::set<const std::string &> & categories)
{
    TRACE();
    _contr.cleanData();
    _contr.getByFilter();
}

void RequestManager::getFavoritesList()
{
    TRACE();
    _contr.cleanData();
    _contr.getFavoritesList();
}
void RequestManager::getLastViewedList()
{
    TRACE();
    _contr.cleanData();
    _contr.getLastViewedList();
}

void RequestManager::getUsersRequests()
{
    TRACE();
    _contr.cleanData();
    _contr.getUsersRequests();
}

void RequestManager::declareInQML()
{
    qmlRegisterSingletonType<RequestManager>("request_manager", 1, 0, "RequestManager", RequestManager::singletoneProvider);
}


QObject* RequestManager::singletoneProvider([[maybe_unused]]QQmlEngine * engine, [[maybe_unused]]QJSEngine * scriptEngine)
{
    auto & obj = instance();
    QQmlEngine::setObjectOwnership(&obj, QQmlEngine::CppOwnership);
    return &obj;
}

RequestManager& RequestManager::instance()
{
    static RequestManager inst;
    return inst;
}
