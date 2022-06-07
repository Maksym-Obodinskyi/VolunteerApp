#define LOG_CATEGORY    "SessionManager"
#define LOG_LEVEL       _TRACE_
#include "Logger.h"

#include "SessionManager.h"

#include <map>

static Request req {
      {1.5, 54.2}
    , "Some short description"
    , "Very short title"
    , {"Category 1", "Category 2"}
    , 8
};

static User user {
    "Maksym"
  , "Obodinskyi"
  , "+380930975704"
  , "OMG"
  , 999.999
};

static const std::map<int, std::pair<Request, User>> requests
{
    {1, {req, user}}
};

SessionManager::SessionManager()
{

}

void SessionManager::getRequests()
{
    TRACE();
    emit updateData(requests);
}

void SessionManager::editRequest()
{
    TRACE();
    emit updateData(requests);
}

void SessionManager::addRequests()
{
    TRACE();
    emit updateData(requests);
}

void SessionManager::getByFilter()
{
    TRACE();
    emit updateData(requests);
}

SessionManager & SessionManager::instance()
{
    static SessionManager obj;
    return obj;
}
