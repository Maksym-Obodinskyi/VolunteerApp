#ifndef CONFIGMANAGER_H
#define CONFIGMANAGER_H

#include <QObject>
#include <map>

#include "Request.h"
#include "User.h"

class ConfigManager : public QObject
{
    Q_OBJECT
public:
    void getUsersRequests();
    void getLastViewed();
    void getFavorites();

    void addToFavorites(const Request & request);


    static ConfigManager & instance();

signals:
    void updateData(std::map<int, std::pair<Request, User>>);

private:
    ConfigManager();
    ConfigManager(const ConfigManager &) = delete;
    ConfigManager(const ConfigManager &&) = delete;
    ConfigManager& operator=(const ConfigManager &) = delete;
    ConfigManager& operator=(const ConfigManager &&) = delete;

    void readUserConfig();

    static std::string FAVORITES_FILE;
    static std::string CONFIG_DIR;
    static std::string USER_CONFIG_FILE;
    std::string                             _userPswd;
    std::map<int, std::pair<Request, User>> _requests;
    User                                    _user;
};

#endif // CONFIGMANAGER_H
