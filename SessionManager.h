#ifndef SESSIONMANAGER_H
#define SESSIONMANAGER_H

#include <QObject>
#include <QQmlEngine>
#include <QTcpSocket>

#include <condition_variable>

#include "Request.h"
#include "User.h"

class SessionManager : public QObject
{
    Q_OBJECT
public:
    std::map<int, std::pair<Request, User>> getRequests();
    void editRequest();
    void addRequests();
    void getByFilter();

    Q_PROPERTY(QString name READ getName NOTIFY userChanged)
    Q_PROPERTY(QString lastName READ getLastName NOTIFY userChanged)
    Q_PROPERTY(QString phone READ getPhone NOTIFY userChanged)
    Q_PROPERTY(QString password READ getPassword)

    Q_PROPERTY(bool signedIn READ getSignedIn NOTIFY signedInChanged)
    Q_PROPERTY(bool accountCreated READ getAccountCreated NOTIFY accountCreatedChanged)

    Q_INVOKABLE void createAccount(QString phone
                                   , QString password
                                   , QString name
                                   , QString lastName
                                   , QString email);
    Q_INVOKABLE void signIn(QString phone, QString password);

    static SessionManager & instance();
    static void declareInQML();
    static QObject* singletoneProvider(QQmlEngine * engine, QJSEngine * scriptEngine);

    void setUser(const User &user);

    QString getPhone();
    QString getPassword();
    QString getName();
    QString getLastName();
    bool getSignedIn();
    void setSignedIn(bool);
    bool getAccountCreated();
    void setAccountCreated(bool);

signals:
    void updateData(std::map<int, std::pair<Request, User>>);
    void userChanged();
    void signedInChanged();
    void accountCreatedChanged();

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

    QTcpSocket socket;

    User _toCreate;

    User _user;
};

#endif // SESSIONMANAGER_H
