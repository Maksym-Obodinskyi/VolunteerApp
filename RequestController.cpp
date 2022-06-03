#define LOG_LEVEL _TRACE_
#define LOG_CATEGORY "RequestController"
#include "Logger.h"

#include "RequestController.h"
#include "SessionManager.h"

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
}

void RequestController::getLastViewedList()
{
    TRACE();
}

void RequestController::getUsersRequests()
{
    TRACE();
    SessionManager::instance().getUsersRequests();
}
