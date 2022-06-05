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
}

void RequestController::addToFavorites()
{
    TRACE();
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
    static RequestController inst;
    return inst;
}
