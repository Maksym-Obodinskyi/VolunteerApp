#include "Request.h"

#include <QQmlEngine>

Request::Request(std::pair<double, double> _location
                 , std::string _description
                 , std::string _title
                 , std::set<std::string> _categories
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
    location = req.location;
    description = req.description;
    title = req.title;
    categories = req.categories;
    date = req.date;
}

Request::Request(Request && req)
{
    location = req.location;
    description = req.description;
    title = req.title;
    categories = req.categories;
    date = req.date;
}

Request& Request::operator=(Request && req)
{
    location = req.location;
    description = req.description;
    title = req.title;
    categories = req.categories;
    date = req.date;
}
Request& Request::operator=(const Request & req)
{
    location = req.location;
    description = req.description;
    title = req.title;
    categories = req.categories;
    date = req.date;
}

void Request::declareInQML()
{
    qmlRegisterType<Request>("request", 1, 0, "Request");
}


double Request::getLatitude()
{
    return location.first;
}

double Request::getLongitude()
{
    return location.second;
}
