#ifndef RESPONCE_H
#define RESPONCE_H

#include <iostream>


#include <QByteArray>

#include <charconv>

struct Responce {
    char type;
    int err;

    Responce(char _type = '|') : type(_type) {}

    virtual QByteArray serialize()
    {
        QByteArray ret;
        ret += type;
        ret += ':';
        char arr[5];
        auto [ptr, ec] = std::to_chars(arr, arr + 5, err);
        if (ec == std::errc()) {
            for (auto symbol = arr; symbol != ptr; symbol++) {
                std::cout << *symbol << std::endl;
                ret += *symbol;
            }
            std::cout << "You are debil" << std::endl;
        } else {
            ret += '9';
        }
        return ret;
    }

    virtual void deserialize(QByteArray arr)
    {
        if (arr.size() > 1) {
            int result;
            const auto[_, ec] = std::from_chars(arr.constData() + 2, arr.constData() + arr.size(), result);

            if (ec == std::errc()) {
                err = result;
            } else {
                err = 1000;
            }
        } else {
            err = 1001;
        }
    }
};


struct LogInResponce : Responce {
    LogInResponce() : Responce('l') {}
};

struct LogOutResponce : Responce {
};

struct NewUserResponce : Responce {
};

struct UpdateProfileResponce : Responce {
};

struct AddRequestResponce : Responce {
};

struct GetRequestResponce : Responce {
};

struct UpdateRequestResponce : Responce {
};

struct RemoveRequestResponce : Responce {
};

#endif // RESPONCE_H
