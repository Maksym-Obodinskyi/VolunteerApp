#define LOG_CATEGORY    "SessionManager"
#define LOG_LEVEL       _TRACE_
#include "Logger.h"

#include "SessionManager.h"
#include "ConfigManager.h"

#include <map>

static Request req {
      {1.5, 54.2}
    , "Some short description"
    , "Very short title"
    , {"Category 1", "Category 2"}
    , 8
};

static User user {
    "Maksym"
  , "Obodinskyi"
  , "+380930975704"
  , "OMG"
  , 999.999
  , "m.obodinskyy@nltu.lviv.ua"
};

static const std::map<int, std::pair<Request, User>> requests
{
    {1, {req, user}}
};

SessionManager::SessionManager()
{
    TRACE();
}

std::map<int, std::pair<Request, User>> SessionManager::getRequests()
{
    TRACE();
    return requests;
}

void SessionManager::editRequest()
{
    TRACE();
//    emit updateData(requests);
}

void SessionManager::addRequests()
{
    TRACE();
//    emit updateData(requests);
}

void SessionManager::getByFilter()
{
    TRACE();
//    emit updateData(requests);
}

bool SessionManager::createAccount(QString phone
                                , QString password
                                , QString name
                                , QString lastName
                                , QString email)
{
    TRACE();
    _user.lastName = lastName.toStdString();
    _user.name = name.toStdString();
    _user.number = phone.toStdString();
    _user.password = password.toStdString();
    _user.email = email.toStdString();

    ConfigManager::instance().saveUser(_user);

    emit userChanged();

    return true;
}

bool SessionManager::signIn(QString phone, QString password)
{
    TRACE();
    INFO("phone - {}, password - {}", phone.toStdString(), password.toStdString());
    return _user.password == password.toStdString();
}

void SessionManager::setUser(User user)
{
    TRACE();
    _user = user;

    emit userChanged();
}

QString SessionManager::getPhone()
{
    TRACE();
    return QString::fromStdString(_user.number);
}

QString SessionManager::getPassword()
{
    TRACE();
    return QString::fromStdString(_user.password);
}

QString SessionManager::getName()
{
    TRACE();
    return QString::fromStdString(_user.name);
}

QString SessionManager::getLastName()
{
    TRACE();
    return QString::fromStdString(_user.lastName);
}

void SessionManager::declareInQML()
{
    TRACE();
    qmlRegisterSingletonType<SessionManager>("session_manager", 1, 0, "SessionManager", SessionManager::singletoneProvider);
}


QObject* SessionManager::singletoneProvider([[maybe_unused]]QQmlEngine * engine, [[maybe_unused]]QJSEngine * scriptEngine)
{
    TRACE();
    auto & obj = instance();
    QQmlEngine::setObjectOwnership(&obj, QQmlEngine::CppOwnership);
    return &obj;
}


SessionManager & SessionManager::instance()
{
    TRACE();
    static SessionManager obj;
    return obj;
}
