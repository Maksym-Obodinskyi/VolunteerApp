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

//static Request lastViewedReq {
//      {1.9, 4.2}
//    , "Some short description-LAST"
//    , "Very short title-LAST"
//    , {"Category 1-LAST", "Category 2-LAST"}
//    , 22
//};

//static User lastViewedUser {
//    "Maksym-LAST"
//  , "Obodinskyi-LAST"
//  , "+380930975704-LAST"
//  , "OMG-LAST"
//  , 45435.454543
//};

//static Request req {
//      {1.5, 54.2}
//    , "Some short description"
//    , "Very short title"
//    , {"Category 1", "Category 2"}
//    , 8
//};

//static User user {
//    "Maksym"
//  , "Obodinskyi"
//  , "+380930975704"
//  , "OMG"
//  , 999.999
//};

//static const std::map<int, std::pair<Request, User>> requests
//{
//    {1, {req, user}}
//};


//static const std::map<int, std::pair<Request, User>> lastViewed
//{
//    {1, {lastViewedReq, lastViewedUser}}
//};

std::string ConfigManager::FAVORITES_FILE;
std::string ConfigManager::CONFIG_DIR;
std::string ConfigManager::USER_CONFIG_FILE;

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

void ConfigManager::addToFavorites(const RequestInfo & request)
{
    std::fstream fs;
    if (!std::filesystem::exists(FAVORITES_FILE)) {
        fs.open(FAVORITES_FILE, std::ios_base::in | std::ios_base::out);
        if (!fs) {
            ERROR("Favorites config not found");
            return;
        }
        fs << "[]";
        fs.close();
    }

    fs.open(FAVORITES_FILE, std::ios_base::in | std::ios_base::out);
    if (!fs) {
        ERROR("Favorites config not found");
        return;
    }

    rapidjson::Document json;
    rapidjson::IStreamWrapper isw(fs);
    json.ParseStream(isw);
    if (json.HasParseError()) {
        ERROR("Failed to parse favorites config");
        return;
    }
    if (!json.IsArray()) {
        ERROR("Favorites are not array json");
        return;
    }

    rapidjson::Value v;
    v.SetObject();

    auto & allocator = json.GetAllocator();

    TRACE();

    rapidjson::Value requestV;
    requestV.SetObject();

//    requestV.AddMember("longitude",     request.location.first,      allocator);
//    requestV.AddMember("latitude",      request.location.second,       allocator);
//    requestV.AddMember("title",         rapidjson::StringRef(request.title.c_str()),          allocator);
//    requestV.AddMember("description",   rapidjson::StringRef(request.description.c_str()),    allocator);
//    requestV.AddMember("categories",    rapidjson::StringRef(request.categories.c_str()), allocator);
//    requestV.AddMember("date",          request.date,           allocator);

    v.AddMember("Request", requestV, allocator);

    rapidjson::Value userV;
    userV.SetObject();

//    userV.AddMember("name",         rapidjson::StringRef(user.name.c_str()),     allocator);
//    userV.AddMember("lastname",     rapidjson::StringRef(user.lastName.c_str()),     allocator);
//    userV.AddMember("number",       rapidjson::StringRef(user.number.c_str()), allocator);
//    userV.AddMember("photo",        rapidjson::StringRef(user.photo.c_str()),    allocator);
//    userV.AddMember("rating",       user.rating,   allocator);
//    userV.AddMember("password",     rapidjson::StringRef(user.photo.c_str()),    allocator);
//    userV.AddMember("email",        rapidjson::StringRef(user.email.c_str()),    allocator);

    v.AddMember("User", userV, allocator);
    v.AddMember("datetime", std::chrono::duration_cast<std::chrono::seconds>
                (std::chrono::system_clock::now().time_since_epoch()).count(), allocator);

    json.PushBack(v, allocator);

    FILE* fp = fopen(FAVORITES_FILE.c_str(), "w");

    char writeBuffer[65536];
    rapidjson::FileWriteStream os(fp, writeBuffer, sizeof(writeBuffer));

    rapidjson::Writer<rapidjson::FileWriteStream> writer(os);
    json.Accept(writer);
    fclose(fp);
}

void ConfigManager::getFavorites()
{
    TRACE();

    std::ifstream ifs(FAVORITES_FILE);
    if (!ifs) {
        ERROR("Favorites config not found");
        return;
    }

    rapidjson::IStreamWrapper   isw(ifs);
    rapidjson::Document         json;
    json.ParseStream(isw);
    if (json.HasParseError()) {
        ERROR("Failed to parse favorites config");
        return;
    }
    if (!json.IsArray()) {
        ERROR("Favorites are not array json");
        return;
    }

    for (auto it = json.Begin(); it != json.End(); it++) {
        const auto & req = *it;
        if (!req.IsObject()) continue;
        if (!req.HasMember("datetime")
         || !req.HasMember("Request")
         || !req.HasMember("User"))
        {
            WARNING("Favorites config is not full");
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
         || !userField.HasMember("rating")
                || !userField.HasMember("email")
                || !userField.HasMember("password"))
        {
            WARNING("Request or User field is not full");
            continue;
        }

        int dateTime        = req["datetime"].GetInt();
//        _requests[dateTime] = RequestInfo({{reqField["longitude"].GetDouble(),reqField["latitude"].GetDouble()}
//                                                            , reqField["description"].GetString()
//                                                            , reqField["title"].GetString()
//                                                            , reqField["categories"].GetString()
//                                                            , reqField["date"].GetInt()},
//                                                            { userField["name"].GetString()
//                                                            , userField["lastname"].GetString()
//                                                            , userField["number"].GetString()
//                                                            , userField["photo"].GetString()
//                                                            , userField["rating"].GetDouble()
//                                                            , userField["email"].GetString()
//                                                            , userField["password"].GetString()});
    }

     updateData(_requests);
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
