#ifndef USER_H
#define USER_H
#include <string>

struct User
{
    User(std::string _name
       , std::string _lastName
       , std::string _number
       , std::string _photo
       , double      _rating);
    User() {}
    std::string name;
    std::string lastName;
    std::string number;
    std::string photo;
    double      rating;
};

#endif // USER_H
