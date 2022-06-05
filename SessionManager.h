#ifndef SESSIONMANAGER_H
#define SESSIONMANAGER_H

#include <QObject>

#include "Request.h"
#include "User.h"

class SessionManager : public QObject
{
    Q_OBJECT
public:
    void getRequests();
    void editRequest();
    void addRequests();
    void getByFilter();

    static SessionManager & instance();

signals:
    void updateData(std::map<int, std::pair<Request, User>>);

private:
    SessionManager();
    SessionManager(const SessionManager &) = delete;
    SessionManager(const SessionManager &&) = delete;
    SessionManager& operator=(const SessionManager &) = delete;
    SessionManager& operator=(const SessionManager &&) = delete;
};

#endif // SESSIONMANAGER_H
