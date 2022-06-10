#define LOG_CATEGORY "Request"
#define LOG_LEVEL _TRACE_
#include "Logger.h"
#include "Request.h"

#include <QQmlEngine>

Request::Request(std::pair<double, double> _location
                 , const std::string & _description
                 , const std::string & _title
                 , const std::string & _categories
                 , int _date) :
                   QObject(nullptr)
                 , location(_location)
                 , description(_description)
                 , title(_title)
                 , categories(_categories)
                 , date(_date)
{
}

Request::Request(const Request & req)
{
    TRACE();
    location = req.location;
    description = req.description;
    title = req.title;
    categories = req.categories;
    date = req.date;
}

Request::Request(Request && req)
{
    TRACE();
    location = req.location;
    description = req.description;
    title = req.title;
    categories = req.categories;
    date = req.date;
}

Request& Request::operator=(Request && req)
{
    TRACE();
    location = req.location;
    description = req.description;
    title = req.title;
    categories = req.categories;
    date = req.date;
}
Request& Request::operator=(const Request & req)
{
    TRACE();
    location = req.location;
    description = req.description;
    title = req.title;
    categories = req.categories;
    date = req.date;
}

void Request::declareInQML()
{
    TRACE();
    qmlRegisterType<Request>("request", 1, 0, "Request");
}


double Request::getLatitude()
{
    TRACE();
    return location.first;
}

double Request::getLongitude()
{
    TRACE();
    return location.second;
}

QString Request::getDescription()
{
  return QString::fromStdString(description);
}

QString Request::getTitle()
{
  return QString::fromStdString(title);
}

QString Request::getCategories()
{
  return QString::fromStdString(categories);
}

int     Request::getDate()
{
  return date;
}
