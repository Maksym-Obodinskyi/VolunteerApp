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

    static ConfigManager & instance();

signals:
    void updateData(std::map<int, std::pair<Request, User>>);

private:
    ConfigManager();
    ConfigManager(const ConfigManager &) = delete;
    ConfigManager(const ConfigManager &&) = delete;
    ConfigManager& operator=(const ConfigManager &) = delete;
    ConfigManager& operator=(const ConfigManager &&) = delete;

    std::map<int, std::pair<Request, User>> _requests;
    static std::string FAVORITES_FILE;
    static std::string CONFIG_DIR;
};

#endif // CONFIGMANAGER_H
