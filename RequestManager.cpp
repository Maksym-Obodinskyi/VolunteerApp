#define LOG_CATEGORY "RequestManager"
#define LOG_LEVEL _TRACE_
#include "Logger.h"

#include <QQmlEngine>
#include <iostream>

#include "RequestManager.h"

RequestManager::RequestManager()
{
    TRACE();
}

void RequestManager::getRequests()
{
    TRACE();
    _contr.getRequests();
}

void RequestManager::addToFavorites(const Request & request)
{
    TRACE();
    _contr.addToFavorites();
}

void RequestManager::editRequest()
{
    TRACE();
    _contr.editRequest();
}

void RequestManager::addRequest(const Request & request)
{
    TRACE();
    _contr.addRequests();
}

void RequestManager::getByFilter(const std::set<const std::string &> & categories)
{
    TRACE();
    _contr.getByFilter();
}

void RequestManager::getFavoritesList()
{
    TRACE();
    _contr.getFavoritesList();
}
void RequestManager::getLastViewedList()
{
    TRACE();
    _contr.getLastViewedList();
}

void RequestManager::getUsersRequests()
{
    TRACE();
    _contr.getUsersRequests();
}

RequestController & RequestManager::getContr()
{
    return _contr;
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
