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

    void addToFavorites(const Request & request, const User & user);
    void saveUser(const User & user);

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
};

#endif // CONFIGMANAGER_H
