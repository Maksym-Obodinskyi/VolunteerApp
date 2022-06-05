#define LOG_LEVEL _TRACE_
#define LOG_CATEGORY "ConfigManager"
#include "Logger.h"

#include "ConfigManager.h"

#include <map>
#include <fstream>
#include <filesystem>
#include <pwd.h>
#include <rapidjson/document.h>
#include <rapidjson/istreamwrapper.h>

static Request lastViewedReq {
      {1.9, 4.2}
    , "Some short description-LAST"
    , "Very short title-LAST"
    , {"Category 1-LAST", "Category 2-LAST"}
    , 22
};

static User lastViewedUser {
    "Maksym-LAST"
  , "Obodinskyi-LAST"
  , "+380930975704-LAST"
  , "OMG-LAST"
  , 45435.454543
};

static Request req {
      {1.5, 54.2}
    , "Some short description"
    , "Very short title"
    , {"Category 1", "Category 2"}
    , 8
};

static User user {
    "Maksym"
  , "Obodinskyi"
  , "+380930975704"
  , "OMG"
  , 999.999
};

static const std::map<int, std::pair<Request, User>> requests
{
    {1, {req, user}}
};


static const std::map<int, std::pair<Request, User>> lastViewed
{
    {1, {lastViewedReq, lastViewedUser}}
};

std::string ConfigManager::FAVORITES_FILE;
std::string ConfigManager::CONFIG_DIR;

ConfigManager::ConfigManager()
{
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
        }
        file.close();
    }
}

ConfigManager & ConfigManager::instance()
{
    static ConfigManager obj;
    return obj;
}

void ConfigManager::getUsersRequests()
{
    TRACE();

    emit updateData(requests);
}

void ConfigManager::getLastViewed()
{
    TRACE();

    emit updateData(lastViewed);
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
         || !userField.HasMember("rating"))
        {
            WARNING("Request or User field is not full");
            continue;
        }

        const auto & categoriesField = reqField["categories"];

        if (!categoriesField.IsArray()) {
            WARNING("Categories field is not array");
            continue;
        }

        std::set<std::string> categories;
        for (auto catIt = categoriesField.Begin(); catIt != categoriesField.End(); catIt++) {
            categories.insert(catIt->GetString());
        }

        int dateTime        = req["datetime"].GetInt();
        _requests[dateTime] = std::make_pair<Request, User>({{reqField["longitude"].GetDouble(),reqField["latitude"].GetDouble()}
                                                            , reqField["description"].GetString()
                                                            , reqField["title"].GetString()
                                                            , categories
                                                            , reqField["date"].GetInt()},
                                                            { userField["name"].GetString()
                                                            , userField["lastname"].GetString()
                                                            , userField["number"].GetString()
                                                            , userField["photo"].GetString()
                                                            , userField["rating"].GetDouble()});
    }

    emit updateData(_requests);
}
