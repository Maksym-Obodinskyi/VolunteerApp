#define LOG_CATEGORY    "User"
#define LOG_LEVEL       _TRACE_
#include "Logger.h"

#include "User.h"

User::User(std::string _name
         , std::string _lastName
         , std::string _number
         , std::string _photo
         , double      _rating
         , std::string _email
         , std::string _password) :
            name(_name)
          , lastName(_lastName)
          , number(_number)
          , photo(_photo)
          , rating(_rating)
          , email(_email)
          , password(_password)
{
    TRACE();
}

User::User(const User & rhs)
{
    name = rhs.name;
    lastName = rhs.lastName;
    number= rhs.number;
    photo = rhs.photo;
    rating = rhs.rating;
    email = rhs.email;
    password = rhs.password;
}

User& User::operator=(const User & rhs)
{
    name = rhs.name;
    lastName = rhs.lastName;
    number= rhs.number;
    photo = rhs.photo;
    rating = rhs.rating;
    email = rhs.email;
    password = rhs.password;
    return *this;
}
