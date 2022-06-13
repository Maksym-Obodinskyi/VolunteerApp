#ifndef CONFIGMANAGER_H
#define CONFIGMANAGER_H

#include <QObject>
#include <map>

#include "RequestInfo.h"
#include "UserInfo.h"

class ConfigManager : public QObject
{
    Q_OBJECT
public:
    void getUsersRequests();
    void getLastViewed();
    void getFavorites();
    void getMyRequest();

    void addToFavorites(const RequestInfo & request);
    void addMyRequest(const RequestInfo & request);
    void saveUser(const UserInfo & user);

    static ConfigManager & instance();

    static std::string FAVORITES_FILE;
    static std::string CONFIG_DIR;
    static std::string USER_CONFIG_FILE;
    static std::string MY_REQUESTS;
signals:
    void updateData(std::map<int, RequestInfo>);

private:
    ConfigManager();
    ConfigManager(const ConfigManager &) = delete;
    ConfigManager(const ConfigManager &&) = delete;
    ConfigManager& operator=(const ConfigManager &) = delete;
    ConfigManager& operator=(const ConfigManager &&) = delete;

    void writeReq(const RequestInfo & req, std::string fileName);
    void getReqs(std::string fileName);

    void readUserConfig();

    std::string                _userPswd;
};

#endif // CONFIGMANAGER_H
