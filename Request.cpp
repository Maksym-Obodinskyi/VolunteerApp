#include "Request.h"

Request::Request(std::pair<double, double> _location
                 , std::string _description
                 , std::string _title
                 , std::set<std::string> _categories
                 , int _date) :
                   location(_location)
                 , description(_description)
                 , title(_title)
                 , categories(_categories)
                 , date(_date)
{
}
