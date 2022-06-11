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

std::map<int, std::pair<Request, User>> RequestController::getRequests()
{
    TRACE();
    return SessionManager::instance().getRequests();
}

void RequestController::addToFavorites(const Request & request, const User & user)
{
    TRACE();

    ConfigManager::instance().addToFavorites(request, user);
}

void RequestController::editRequest()
{
    TRACE();
}

void RequestController::addRequests()
{
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
    ConfigManager::instance().getUsersRequests();
}

void RequestController::cleanData()
{
    TRACE();
    emit cleanModel();
}

RequestController& RequestController::instance()
{
    TRACE();
    static RequestController inst;
    return inst;
}
