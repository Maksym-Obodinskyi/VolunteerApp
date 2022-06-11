#define LOG_CATEGORY    "SessionManager"
#define LOG_LEVEL       _TRACE_
#include "Logger.h"

#include "SessionManager.h"
#include "ConfigManager.h"
#include "message.h"
#include "responce.h"

#include <map>
#include <chrono>
#include <QHostAddress>
using namespace std::chrono_literals;

static Request req {
      {49.83550884520322, 24.02324415870541}
    , "Very huilo"
    , "Putin huilo lalalalalalalal"
    , "Category 1"
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
    socket.connectToHost(QHostAddress("127.0.0.1"), 4243);
    connect(&socket, SIGNAL(readyRead()), this, SLOT(onReadyRead()));
}

void SessionManager::onReadyRead()
{
    TRACE();
    QByteArray datas = socket.readAll();
    DEBUG("datas: {}", datas.toStdString());

    for (auto byte : datas) {
        INFO("{}", byte);
    }

    Responce * resp;

    char comm;


    if (datas.size() > 3) {
        comm = datas[0];
        if (datas[1] != ':') {
            WARNING("Unrecognized protocol");
        }
    } else {
        return;
    }

    switch(comm)
    {
        case 'l':
        {
            resp = new LogInResponce;
            resp->deserialize(datas.constData() + 2);
            setSignedIn(resp->err == 0);
            break;
        }
        //        case 'd':
        //        {
        //            resp = new LogOutResponce;
        //        }
        //        case 'p':
        //        {
        //            resp = new UpdateProfileResponce;
        //        }
        //        case 'u':
        //        {
        //            resp = new LogInResponce;
        //        }
        //        case 'n':
        //        {
        //            resp = new LogInResponce;
        //        }
        //        case 'a':
        //        {
        //            resp = new LogInResponce;
        //        }
        //        case 'r':
        //        {
        //            resp = new LogInResponce;
        //        }
        //        case 'g':
        //        {
        //            resp = new LogInResponce;
        //        }
        default:
            WARNING("Undefined command received");
            return;
    }
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

void SessionManager::createAccount(QString phone
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
}

void SessionManager::signIn(QString phone, QString password)
{
    TRACE();
    errorCode = -1;
    INFO("phone - {}, password - {}", phone.toStdString(), password.toStdString());

    MessageLogIn msg;

    msg.setPassword(password);
    msg.setPhoneNumber(phone);

    socket.write(msg.serialize());
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

bool SessionManager::getSignedIn()
{
    return signedIn;
}
void SessionManager::setSignedIn(bool var)
{
    if (var != signedIn) {
        signedIn = var;
        emit signedInChanged();
    }
}
