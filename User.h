#ifndef USER_H
#define USER_H
#include <string>

struct User
{
    User(std::string _name
       , std::string _lastName
       , std::string _number
       , std::string _photo
       , double      _rating
       , std::string _email
       , std::string _password = std::string());
    User() {}
    User(const User & rhs);
    User& operator=(const User & rhs);
    std::string name;
    std::string lastName;
    std::string number;
    std::string photo;
    double      rating;
    std::string email;
    std::string password;
};

#endif // USER_H
