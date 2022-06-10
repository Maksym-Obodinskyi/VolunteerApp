#ifndef SESSIONMANAGER_H
#define SESSIONMANAGER_H

#include <QObject>
#include <QQmlEngine>

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

    Q_INVOKABLE bool createAccount(QString phone
                                   , QString password
                                   , QString name
                                   , QString lastName
                                   , QString email);
    Q_INVOKABLE bool signIn(QString phone, QString password);

    static SessionManager & instance();
    static void declareInQML();
    static QObject* singletoneProvider(QQmlEngine * engine, QJSEngine * scriptEngine);

    void setUser(User user);

    QString getPhone();
    QString getPassword();
    QString getName();
    QString getLastName();

signals:
    void updateData(std::map<int, std::pair<Request, User>>);
    void userChanged();

private:
    SessionManager();
    SessionManager(const SessionManager &) = delete;
    SessionManager(const SessionManager &&) = delete;
    SessionManager& operator=(const SessionManager &) = delete;
    SessionManager& operator=(const SessionManager &&) = delete;

    User _user;
};

#endif // SESSIONMANAGER_H
