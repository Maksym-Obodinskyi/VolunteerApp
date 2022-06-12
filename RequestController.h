#ifndef REQUESTCONTROLLER_H
#define REQUESTCONTROLLER_H

#include <QObject>

#include "RequestInfo.h"
#include "UserInfo.h"

class RequestController : public QObject
{
    Q_OBJECT
public:
    void getRequests();
    void addToFavorites(const RequestInfo & request);
    void editRequest();
    void addRequest(double latitude
                    , double longitude
                    , QString title
                    , QString description
                    , QString categories
                    , int date);
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
