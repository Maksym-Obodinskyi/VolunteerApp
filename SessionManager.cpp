#define LOG_CATEGORY    "SessionManager"
#define LOG_LEVEL       _TRACE_
#include "Logger.h"

#include "SessionManager.h"

#include <map>

std::pair<double, double> location;
std::string description;
std::string title;
std::set<std::string> categories;
int date;


std::string name;
std::string lastName;
std::string number;
std::string photo;
double      rating;

Request req {
      {1.5, 54.2}
    , "Some short description"
    , "Very short title"
    , {"Category 1", "Category 2"}
    , 8
};
User user {
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

void SessionManager::getUsersRequests()
{
    TRACE();
    INFO("requests size - {}", requests.size());

//    for(const auto & [date, data] : requests) {
//        INFO("key - %d, requestTitle - %s, userName - %s", date, data.first.title.c_str(), data.second._name.c_str());
//    }

    emit updateData(requests);
}

SessionManager & SessionManager::instance()
{
    static SessionManager obj;
    return obj;
}
