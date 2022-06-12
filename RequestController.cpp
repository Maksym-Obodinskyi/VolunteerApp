#define LOG_LEVEL _TRACE_
#define LOG_CATEGORY "RequestController"
#include "Logger.h"

#include "RequestController.h"
#include "SessionManager.h"
#include "ConfigManager.h"

RequestController::RequestController()
{
    TRACE();

}

void RequestController::getRequests()
{
    TRACE();
    SessionManager::instance().getRequests();
}

void RequestController::addToFavorites(const RequestInfo & request)
{
    TRACE();

    ConfigManager::instance().addToFavorites(request);
}

void RequestController::editRequest()
{
    TRACE();
}

void RequestController::addRequest(double latitude
                                   , double longitude
                                   , QString title
                                   , QString description
                                   , QString categories
                                   , int date)
{
    RequestInfo req;
    req.userInfo = SessionManager::instance().getUser();
    req._location.E = latitude;
    req._location.N = longitude;
    req.title = title;
    req.description = description;
    req.categories = categories;
    req.date = date;
    SessionManager::instance().addRequest(req);
    TRACE();
}

void RequestController::getByFilter()
{
    TRACE();
}

void RequestController::getFavoritesList()
{
    TRACE();
    ConfigManager::instance().getFavorites();
}

void RequestController::getLastViewedList()
{
    TRACE();
    ConfigManager::instance().getLastViewed();
}

void RequestController::getUsersRequests()
{
    TRACE();
    ConfigManager::instance().getMyRequest();
}

void RequestController::cleanData()
{
    TRACE();
     cleanModel();
}

RequestController& RequestController::instance()
{
    TRACE();
    static RequestController inst;
    return inst;
}
