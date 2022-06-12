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

SessionManager::SessionManager() : signedIn(false), accountCreated(false)
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

    std::unique_ptr<Responce> resp;

    char comm;

    if (datas.startsWith('c')) {
        INFO("Successfully connected!");
        return;
    }

    if (datas.size() >= 3) {
        comm = datas[0];
        if (datas[1] != ':') {
            WARNING("Unrecognized protocol");
        }
    } else {
        ERROR("Size is so small - {}", datas.size());
        return;
    }

    switch(comm)
    {
        case 'l':
        {
            TRACE();
            resp.reset(new LogInResponce);
            resp->deserialize(datas.constData() + 2);
            setSignedIn(resp->err == 0);
            ConfigManager::instance().saveUser(_user);
            break;
        }
        case 'n':
        {
            TRACE();
            resp.reset(new NewUserResponce);
            resp->deserialize(datas.constData() + 2);
            if (resp->err == 0) {
                TRACE();
                setUser(_toCreate);
                _toCreate = User();
                setAccountCreated(true);
                ConfigManager::instance().saveUser(_user);
                emit userChanged();
            } else {
                setAccountCreated(false);
            }
            break;
        }
        case 'a':
        {
            resp.reset(new AddRequestResponce);
            resp->deserialize(datas.constData() + 2);
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

void SessionManager::addRequest(const Request & req)
{
    TRACE();
    MessageAddRequest msg;

    msg.setRequestInfo(_user.number.c_str(),
                       req.location.first,
                       req.location.second,
                       req.description.c_str(),
                       req.title.c_str(),
                       req.categories.c_str(),
                       0,
                       req.date);


    socket.write(msg.serialize());
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
    _toCreate.lastName = lastName.toStdString();
    _toCreate.name = name.toStdString();
    _toCreate.number = phone.toStdString();
    _toCreate.password = password.toStdString();
    _toCreate.email = email.toStdString();

    MessageNewUser msg;

    msg.setUserInfo(email, password, name, lastName, phone, "");

    socket.write(msg.serialize());
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

void SessionManager::setUser(const User &user)
{
    TRACE();
    INFO("name - {}", user.name);
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
    signedIn = var;
    emit signedInChanged();
}

bool SessionManager::getAccountCreated()
{
    return accountCreated;
}

void SessionManager::setAccountCreated(bool var)
{
    accountCreated = var;
    emit accountCreatedChanged();
}
