#define LOG_CATEGORY    "SessionManager"
#define LOG_LEVEL       _TRACE_
#include "Logger.h"

#include "SessionManager.h"
#include "ConfigManager.h"
#include "RequestManager.h"
#include "message.h"
#include "responce.h"

#include <map>
#include <chrono>
#include <QHostAddress>
using namespace std::chrono_literals;

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
            LogInResponce resp;
            resp.deserialize(datas.constData() + 2);
            DEBUG("err - {}", resp.err);
            if (!resp.err) {
                setSignedIn(true);
                resp.userInfo.password = password;
                ConfigManager::instance().saveUser(resp.userInfo);
                setUser(resp.userInfo);
                RequestManager::instance().getRequests();
            } else {
                setSignedIn(false);
            }
            break;
        }
        case 'n':
        {
            TRACE();
            NewUserResponce resp;
            resp.deserialize(datas.constData() + 2);
            if (!resp.err) {
                TRACE();
                setUser(_tmp);
                _tmp = UserInfo();
                setAccountCreated(true);
                ConfigManager::instance().saveUser(_user);
                RequestManager::instance().getRequests();
            } else {
                setAccountCreated(false);
            }
            break;
        }
        case 'a':
        {
            AddRequestResponce resp;
            resp.deserialize(datas.constData() + 2);
            RequestManager::instance().getRequests();
            ConfigManager::instance().addMyRequest(_reqToCreate);
            break;
        }
        case 'g':
        {
            GetRequestResponce resp;
            resp.deserialize(datas.constData() + 2);
            for(const auto & item : resp.requestsList) {
                if (!item.userInfo.picture.isNull()) {
                    item.userInfo.picture.save(QString::fromStdString(ConfigManager::CONFIG_DIR) + '/' + item.userInfo.phoneNumber);
                }
                data.append(QVariant::fromValue(item));
            }

            emit updateRequests();
            break;
        }
        case 'p':
        {
            UpdateProfileResponce resp;
            resp.deserialize(datas.constData() + 2);

            if (!resp.err) {
                _user = _tmp;
            }
            break;
        }
//        case 'd':
//        {
//            resp = new LogOutResponce;
//        }
        //        case 'u':
        //        {
        //            resp = new LogInResponce;
        //        }
        //        case 'r':
        //        {
        //            resp = new LogInResponce;
        //        }
        default:
            WARNING("Undefined command received");
            return;
    }
}

void SessionManager::getRequests()
{
    TRACE();
    MessageGetRequest msg;
//    msg.setFilter("Food");
    socket.write(msg.serialize());
}

void SessionManager::editRequest()
{
    TRACE();
//     updateData(requests);
}

void SessionManager::addRequest(const RequestInfo & req)
{
    TRACE();
    MessageAddRequest msg;

    msg.setRequestInfo(req.userInfo.phoneNumber,
                       req._location.E,
                       req._location.N,
                       req.description,
                       req.title,
                       req.categories,
                       0,
                       req.date);

    _reqToCreate = req;

    socket.write(msg.serialize());
}

void SessionManager::getByFilter()
{
    TRACE();
//     updateData(requests);
}

void SessionManager::createAccount(QString phone
                                , QString password
                                , QString name
                                , QString lastName
                                , QString email)
{
    TRACE();
    _tmp.lastName = lastName;
    _tmp.name = name;
    _tmp.phoneNumber = phone;
    _tmp.password = password;
    _tmp.email = email;

    MessageNewUser msg;

    msg.setUserInfo(email, password, name, lastName, phone);

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
    this->password = password;

    socket.write(msg.serialize());
}

void SessionManager::setUser(const UserInfo &user)
{
    TRACE();
    DEBUG("name - {}, lastName - {}, phone - {}, password - {}, email - {}"
          , user.name.toStdString()
          , user.lastName.toStdString()
          , user.phoneNumber.toStdString()
          , user.password.toStdString()
          , user.email.toStdString())
    _user = user;

     emit userChanged();
}

QString SessionManager::getPhone()
{
    TRACE();
    return _user.phoneNumber;
}

QString SessionManager::getPassword()
{
    TRACE();
    return _user.password;
}

QString SessionManager::getName()
{
    TRACE();
    return _user.name;
}

QString SessionManager::getLastName()
{
    TRACE();
    return _user.lastName;
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

UserInfo SessionManager::getUser()
{
    return _user;
}

QVariantList SessionManager::getData()
{
    return data;
}

QString SessionManager::getEmail()
{
    return _user.email;
}

QString SessionManager::getPhoto()
{
    return QString("file://" + QString::fromStdString(ConfigManager::CONFIG_DIR) + '/' + _user.phoneNumber + ".png") ;
}

void SessionManager::editAccount(QString phone
                                 , QString password
                                 , QString name
                                 , QString lastName
                                 , QString email
                                 , QString picturePath)
{
    DEBUG("pic path - {}", picturePath.toStdString());
    if (!picturePath.isEmpty()) {
        picturePath.remove(0, 7);
        QImage pict(picturePath);
        _tmp.picture = pict.scaled(90, 90);
    }
    _tmp.email = email;
    _tmp.password = password;
    _tmp.name = name;
    _tmp.lastName = lastName;
    _tmp.phoneNumber = phone;

    MessageUpdateProfile msg;
    msg.setUserInfo(email, password, name, lastName, phone, _tmp.picture);
    socket.write(msg.serialize());
}
