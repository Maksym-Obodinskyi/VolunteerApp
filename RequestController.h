#ifndef REQUESTCONTROLLER_H
#define REQUESTCONTROLLER_H

#include <QObject>

#include "Request.h"
#include "User.h"

class RequestController : public QObject
{
    Q_OBJECT
public:
    void getRequests();
    void addToFavorites(const Request & request, const User & user);
    void editRequest();
    void addRequests();
    void getByFilter();
    void getFavoritesList();
    void getLastViewedList();
    void getUsersRequests();
    void cleanData();

    static RequestController& instance();

signals:
    void cleanModel();

private:
    RequestController();
    RequestController(const RequestController &) = delete;
    RequestController(const RequestController &&) = delete;
    RequestController& operator=(const RequestController &) = delete;
    RequestController& operator=(const RequestController &&) = delete;
};
#endif // REQUESTCONTROLLER_H
