#ifndef REQUESTCONTROLLER_H
#define REQUESTCONTROLLER_H


class RequestController
{
public:
    RequestController();
    void getRequests();
    void addToFavorites();
    void editRequest();
    void addRequests();
    void getByFilter();
    void getFavoritesList();
    void getLastViewedList();
    void getUsersRequests();
};
#endif // REQUESTCONTROLLER_H
