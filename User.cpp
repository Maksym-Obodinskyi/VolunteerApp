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

}
