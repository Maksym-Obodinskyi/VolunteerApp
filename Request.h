#ifndef REQUEST_H
#define REQUEST_H
#include <string>
#include <set>

struct Request
{
public:
    Request(std::pair<double, double> _location
          , std::string _description
          , std::string _title
          , std::set<std::string> _categories
          , int _date);
    Request() {}

    std::pair<double, double> location;
    std::string description;
    std::string title;
    std::set<std::string> categories;
    int date;
};

#endif // REQUEST_H
