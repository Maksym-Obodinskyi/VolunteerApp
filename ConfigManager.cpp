#define LOG_LEVEL _TRACE_
#define LOG_CATEGORY "ConfigManager"
#include "Logger.h"

#include "ConfigManager.h"
#include "SessionManager.h"

#include <unistd.h>
#include <sys/types.h>
#include <map>
#include <fstream>
#include <filesystem>
#include <pwd.h>

#define RAPIDJSON_HAS_STDSTRING 1
#include <rapidjson/document.h>
#include <rapidjson/istreamwrapper.h>
#include "rapidjson/filewritestream.h"
#include <rapidjson/writer.h>
#include <chrono>

std::string ConfigManager::FAVORITES_FILE;
std::string ConfigManager::CONFIG_DIR;
std::string ConfigManager::USER_CONFIG_FILE;
std::string ConfigManager::MY_REQUESTS;

ConfigManager::ConfigManager()
{
    TRACE();
    struct passwd *pw = getpwuid(getuid());
    CONFIG_DIR = pw->pw_dir;
    CONFIG_DIR += "/.VolunteerApp";
    INFO("pw_dir - {}", pw->pw_dir);

    if (!std::filesystem::exists(CONFIG_DIR)) {
        std::error_code err;
        INFO("{} directory doesn't exist, creating", CONFIG_DIR);
        std::filesystem::create_directories(CONFIG_DIR, err);
        if (err) {
            ERROR("Failed to create {} directory, error: {}", CONFIG_DIR, err.message());
        }
    }

    FAVORITES_FILE = CONFIG_DIR + "/favorites.json";
    if (!std::filesystem::exists(FAVORITES_FILE)) {
        std::error_code err;
        INFO("{} file doesn't exist, creating", FAVORITES_FILE);
        std::ofstream file(FAVORITES_FILE);

        if (!file.is_open()) {
            ERROR("Failed to create json file: {}", FAVORITES_FILE);
        } else {
            file << "[]";
            file.close();
        }
    }

    MY_REQUESTS = CONFIG_DIR + "/myRequests.json";
    if (!std::filesystem::exists(MY_REQUESTS)) {
        std::error_code err;
        INFO("{} file doesn't exist, creating", MY_REQUESTS);
        std::ofstream file(MY_REQUESTS);

        if (!file.is_open()) {
            ERROR("Failed to create json file: {}", MY_REQUESTS);
        } else {
            file << "[]";
            file.close();
        }
    }

    USER_CONFIG_FILE = CONFIG_DIR + "/user.json";

    readUserConfig();
}

void ConfigManager::readUserConfig()
{
    TRACE();
    UserInfo _user;

    std::ifstream ifs(USER_CONFIG_FILE);
    if (!ifs) {
        ERROR("User config not found");
        return;
    }

    rapidjson::IStreamWrapper   isw(ifs);
    rapidjson::Document         json;
    json.ParseStream(isw);
    if (json.HasParseError()) {
        ERROR("Failed to parse user config");
        return;
    }
    if (!json.IsObject()) {
        ERROR("User is not object");
        return;
    }

    if (!json.HasMember("name")
     || !json.HasMember("lastname")
     || !json.HasMember("number")
     || !json.HasMember("photo")
     || !json.HasMember("password")
     || !json.HasMember("email"))
    {
        WARNING("User config is not full");
        return;
    }

    _user.name        = json["name"].GetString();
    _user.lastName    = json["lastname"].GetString();
    _user.phoneNumber = json["number"].GetString();
    _user.picture     = json["photo"].GetString();
    _user.password    = json["password"].GetString();
    _user.email       = json["email"].GetString();

    DEBUG("name - {}, lastName - {}, phone - {}, password - {}, email - {}"
          , _user.name.toStdString()
          , _user.lastName.toStdString()
          , _user.phoneNumber.toStdString()
          , _user.password.toStdString()
          , _user.email.toStdString())

    SessionManager::instance().setUser(_user);
}

ConfigManager & ConfigManager::instance()
{
    static ConfigManager obj;
    return obj;
}

void ConfigManager::getUsersRequests()
{
    TRACE();

//     updateData(requests);
}

void ConfigManager::getLastViewed()
{
    TRACE();

//     updateData(lastViewed);
}

void ConfigManager::addToFavorites(const RequestInfo & req)
{
    writeReq(req, FAVORITES_FILE);
}

void ConfigManager::getFavorites()
{
    TRACE();
    getReqs(FAVORITES_FILE);
}

void ConfigManager::addMyRequest(const RequestInfo & req)
{
    writeReq(req, MY_REQUESTS);
}

void ConfigManager::getMyRequest()
{
    getReqs(MY_REQUESTS);
}

void ConfigManager::saveUser(const UserInfo & user)
{
    TRACE();
    INFO("name - {}, lastName = {}, number - {}, password - {}, email - {}"
         , user.name.toStdString()
         , user.lastName.toStdString()
         , user.phoneNumber.toStdString()
         , user.password.toStdString()
         , user.email.toStdString());
    rapidjson::Document json;
    auto & allocator = json.GetAllocator();
    json.SetObject();

    json.AddMember("name",      user.name.toStdString(),           allocator);
    json.AddMember("lastname",  user.lastName.toStdString(),       allocator);
    json.AddMember("number",    user.phoneNumber.toStdString(),    allocator);
    json.AddMember("photo",     user.picture.toStdString(),        allocator);
    json.AddMember("password",  user.password.toStdString(),       allocator);
    json.AddMember("email",     user.email.toStdString(),          allocator);

    FILE* fp = fopen(USER_CONFIG_FILE.c_str(), "w");

    char writeBuffer[65536];
    rapidjson::FileWriteStream os(fp, writeBuffer, sizeof(writeBuffer));

    rapidjson::Writer<rapidjson::FileWriteStream> writer(os);
    json.Accept(writer);
    fclose(fp);
}

void ConfigManager::writeReq(const RequestInfo & req, std::string fileName)
{
    INFO("name - {}, lastName = {}, number - {}, password - {}, email - {}, title - {}, description - {}"
         , req.userInfo.name.toStdString()
         , req.userInfo.lastName.toStdString()
         , req.userInfo.phoneNumber.toStdString()
         , req.userInfo.password.toStdString()
         , req.userInfo.email.toStdString()
         , req.title.toStdString()
         , req.description.toStdString());
    std::fstream fs;
    if (!std::filesystem::exists(fileName)) {
        fs.open(fileName, std::ios_base::in | std::ios_base::out);
        if (!fs) {
            ERROR("File not found - {}", fileName);
            return;
        }
        fs << "[]";
        fs.close();
    }

    fs.open(fileName, std::ios_base::in | std::ios_base::out);
    if (!fs) {
        ERROR("File not found - {}", fileName);
        return;
    }

    rapidjson::Document json;
    rapidjson::IStreamWrapper isw(fs);
    json.ParseStream(isw);
    if (json.HasParseError()) {
        ERROR("Failed to parse config - {}", fileName);
        return;
    }
    if (!json.IsArray()) {
        ERROR("File {} are not array json", fileName);
        return;
    }

    rapidjson::Value v;
    v.SetObject();

    auto & allocator = json.GetAllocator();

    TRACE();

    rapidjson::Value requestV;
    requestV.SetObject();

    requestV.AddMember("longitude",     req._location.E,      allocator);
    requestV.AddMember("latitude",      req._location.N,       allocator);
    requestV.AddMember("title",         req.title.toStdString(),          allocator);
    requestV.AddMember("description",   req.description.toStdString(),    allocator);
    requestV.AddMember("categories",    req.categories.toStdString(), allocator);
    requestV.AddMember("date",          req.date,           allocator);

    v.AddMember("Request", requestV, allocator);

    rapidjson::Value userV;
    userV.SetObject();

    userV.AddMember("name",         req.userInfo.name.toStdString(),     allocator);
    userV.AddMember("lastname",     req.userInfo.lastName.toStdString(),     allocator);
    userV.AddMember("number",       req.userInfo.phoneNumber.toStdString(), allocator);
    userV.AddMember("photo",        req.userInfo.picture.toStdString(),    allocator);
    userV.AddMember("password",     req.userInfo.password.toStdString(),    allocator);
    userV.AddMember("email",        req.userInfo.email.toStdString(),    allocator);

    v.AddMember("User", userV, allocator);

    json.PushBack(v, allocator);

    FILE* fp = fopen(fileName.c_str(), "w");

    char writeBuffer[65536];
    rapidjson::FileWriteStream os(fp, writeBuffer, sizeof(writeBuffer));

    rapidjson::Writer<rapidjson::FileWriteStream> writer(os);
    json.Accept(writer);
    fclose(fp);
}

void ConfigManager::getReqs(std::string fileName)
{
    std::map<int, RequestInfo> reqs;
    std::ifstream ifs(fileName);
    if (!ifs) {
        ERROR("Config not found - {}", fileName);
        return;
    }

    rapidjson::IStreamWrapper   isw(ifs);
    rapidjson::Document         json;
    json.ParseStream(isw);
    if (json.HasParseError()) {
        ERROR("Failed to parse config - {}", fileName);
        return;
    }
    if (!json.IsArray()) {
        ERROR("Config are not array json - {}", fileName);
        return;
    }

    for (auto it = json.Begin(); it != json.End(); it++) {
        const auto & req = *it;
        if (!req.IsObject()) continue;
        if (!req.HasMember("Request")
         || !req.HasMember("User"))
        {
            WARNING("Config is not full - {}", fileName);
            continue;
        }
        if (!req["Request"].IsObject()
         || !req["User"].IsObject())
        {
            WARNING("Request or User field is not objects");
            continue;
        }

        const auto & reqField  = req["Request"];
        const auto & userField = req["User"];

        if (!reqField.HasMember("longitude")
         || !reqField.HasMember("latitude")
         || !reqField.HasMember("title")
         || !reqField.HasMember("description")
         || !reqField.HasMember("categories")
         || !reqField.HasMember("date")
         || !userField.HasMember("name")
         || !userField.HasMember("lastname")
         || !userField.HasMember("number")
         || !userField.HasMember("photo")
                || !userField.HasMember("email")
                || !userField.HasMember("password"))
        {
            WARNING("Request or User field is not full");
            continue;
        }

        RequestInfo info;
        info._location.E            = reqField["latitude"].GetDouble();
        info._location.N            = reqField["longitude"].GetDouble();
        info.description            = reqField["description"].GetString();
        info.title                  = reqField["title"].GetString();
        info.categories             = reqField["categories"].GetString();
        info.date                   = reqField["date"].GetInt();
        info.userInfo.name          = userField["name"].GetString();
        info.userInfo.lastName      = userField["lastname"].GetString();
        info.userInfo.phoneNumber   = userField["number"].GetString();
        info.userInfo.picture       = userField["photo"].GetString();
        info.userInfo.email         = userField["email"].GetString();
        info.userInfo.password      = userField["password"].GetString();
        info.userInfo.name          = userField["name"].GetString();
        reqs[info.date] = info;
    }

     updateData(reqs);
}
