#ifndef SESSIONMANAGER_H
#define SESSIONMANAGER_H

#include <QObject>
#include <QQmlEngine>
#include <QTcpSocket>

#include <condition_variable>

#include "RequestInfo.h"
#include "UserInfo.h"

class SessionManager : public QObject
{
    Q_OBJECT
public:
    void getRequests();
    void editRequest();
    void addRequest(const RequestInfo & req);
    void getByFilter();

    Q_PROPERTY(QString name READ getName NOTIFY userChanged)
    Q_PROPERTY(QString lastName READ getLastName NOTIFY userChanged)
    Q_PROPERTY(QString phone READ getPhone NOTIFY userChanged)
    Q_PROPERTY(QString password READ getPassword NOTIFY userChanged)
    Q_PROPERTY(QString email READ getEmail NOTIFY userChanged)

    Q_PROPERTY(bool signedIn READ getSignedIn NOTIFY signedInChanged)
    Q_PROPERTY(bool accountCreated READ getAccountCreated NOTIFY accountCreatedChanged)

    Q_PROPERTY(QVariantList data READ getData CONSTANT)

    Q_INVOKABLE void createAccount(QString phone
                                   , QString password
                                   , QString name
                                   , QString lastName
                                   , QString email);
    Q_INVOKABLE void editAccount(QString phone
                                 , QString password
                                 , QString name
                                 , QString lastName
                                 , QString email
                                 , QString picturePath);
    Q_INVOKABLE void signIn(QString phone, QString password);

    static SessionManager & instance();
    static void declareInQML();
    static QObject* singletoneProvider(QQmlEngine * engine, QJSEngine * scriptEngine);

    void setUser(const UserInfo &user);

    QString getPhone();
    QString getPassword();
    QString getName();
    QString getLastName();
    QString getEmail();
    bool getSignedIn();
    void setSignedIn(bool);
    bool getAccountCreated();
    void setAccountCreated(bool);



    QVariantList getData();
    UserInfo getUser();

signals:
    void updateData(std::map<int, RequestInfo>);
    void userChanged();
    void signedInChanged();
    void accountCreatedChanged();
    void updateRequests();

private slots:
    void onReadyRead();

private:
    SessionManager();
    SessionManager(const SessionManager &) = delete;
    SessionManager(const SessionManager &&) = delete;
    SessionManager& operator=(const SessionManager &) = delete;
    SessionManager& operator=(const SessionManager &&) = delete;

    bool signedIn;
    bool accountCreated;
    int errorCode{-1};

    QVariantList data;

    QTcpSocket socket;

    UserInfo _tmp;
    RequestInfo _reqToCreate;

    UserInfo _user;
};

#endif // SESSIONMANAGER_H
