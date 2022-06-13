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

void RequestManager::getRequests()
{
    TRACE();
    _contr.getRequests();
}

void RequestManager::addToFavorites(QString name
                                    , QString lastName
                                    , QString email
                                    , QString phone
                                    , double latitude
                                    , double longitude
                                    , QString title
                                    , QString description
                                    , int date)
{
    TRACE();
    RequestInfo req;
    req.userInfo.name = name;
    req.userInfo.lastName = lastName;
    req.userInfo.email = email;
    req.userInfo.phoneNumber = phone;
    req._location.E = latitude;
    req._location.N = longitude;
    req.title = title;
    req.description = description;
    req.date = date;
    _contr.addToFavorites(req);
}

void RequestManager::editRequest()
{
    TRACE();
    _contr.cleanData();
    _contr.editRequest();
}

void RequestManager::addRequest(double latitude
                                , double longitude
                                , QString title
                                , QString description
                                , QString categories
                                , int date)
{
    TRACE();
    _contr.cleanData();
    _contr.addRequest(latitude, longitude, title, description, categories, date);
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
    TRACE();
    qmlRegisterSingletonType<RequestManager>("request_manager", 1, 0, "RequestManager", RequestManager::singletoneProvider);
}


QObject* RequestManager::singletoneProvider([[maybe_unused]]QQmlEngine * engine, [[maybe_unused]]QJSEngine * scriptEngine)
{
    TRACE();
    auto & obj = instance();
    QQmlEngine::setObjectOwnership(&obj, QQmlEngine::CppOwnership);
    return &obj;
}

RequestManager& RequestManager::instance()
{
    TRACE();
    static RequestManager inst;
    return inst;
}
