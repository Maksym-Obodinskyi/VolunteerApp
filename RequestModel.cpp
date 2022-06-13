#define LOG_CATEGORY "RequestModel"
#define LOG_LEVEL _TRACE_
#include "Logger.h"

#include <QQmlEngine>

#include "RequestModel.h"
#include "RequestManager.h"
#include "SessionManager.h"
#include "ConfigManager.h"
#include "RequestController.h"

RequestModel::RequestModel(QObject *parent) : QAbstractListModel(parent)
{
    TRACE();
    connect(&SessionManager::instance(),    SIGNAL(updateData(std::map<int, RequestInfo>)),
            this,                           SLOT(updateData(std::map<int, RequestInfo>)));
    connect(&ConfigManager::instance(),     SIGNAL(updateData(std::map<int, RequestInfo>)),
            this,                           SLOT(updateData(std::map<int, RequestInfo>)));
    connect(&RequestController::instance(), SIGNAL(cleanModel()),
            this,                           SLOT(cleanData()));
}

void RequestModel::updateData(std::map<int, RequestInfo> data)
{
    TRACE();
    INFO("size - {}", data.size());
    if (!data.empty()) {
        beginRemoveRows(QModelIndex(), 0, _data.size() - 1);
        _data.clear();
        endRemoveRows();
    }

    _data.reserve(data.size());
    beginInsertRows(QModelIndex(), 0, data.size() - 1);
    for (const auto & [time, item]: data) {
        _data.push_back(std::make_pair(time, item));
    }
    endInsertRows();
}

void RequestModel::cleanData()
{
    TRACE();
    if (_data.empty()) {
        return;
    }

    beginRemoveRows(QModelIndex(), 0, _data.size() - 1);
    _data.clear();
    endRemoveRows();
}

int RequestModel::rowCount([[maybe_unused]]const QModelIndex& parent) const
{
    TRACE();
    return _data.size();
}

QVariant RequestModel::data(const QModelIndex& index, int role) const
{
    TRACE();
    if (!index.isValid())
        return QVariant();

    INFO("row - {}, ", index.row());

    const auto & [time, req] = _data[index.row()];

    switch (role) {
        case Name:          return req.userInfo.name;
        case lastName:      return req.userInfo.lastName;
        case Number:        return req.userInfo.phoneNumber;
        case Photo:         return QString("file://") + QString::fromStdString(ConfigManager::CONFIG_DIR) + '/' + req.userInfo.phoneNumber;
        case Email:         return req.userInfo.email;
        case Description:   return req.description;
        case Title:         return req.title;
        case Date:          return req.date;
        case Categories:    return req.categories;
        case Latitude:      return req._location.E;
        case Longitude:     return req._location.N;
        default:
            WARNING("Unexpectedly received default");
            return QVariant();
            break;
    };
}

QHash<int, QByteArray> RequestModel::roleNames() const
{
    TRACE();
    static QHash<int, QByteArray> mapping {
          {Roles::Name,         "name"}
        , {Roles::lastName,     "lastName"}
        , {Roles::Number,       "number"}
        , {Roles::Photo,        "photo"}
        , {Roles::Email,        "email"}
        , {Roles::Latitude,     "latitude"}
        , {Roles::Longitude,    "longitude"}
        , {Roles::Description,  "description"}
        , {Roles::Title,        "title"}
        , {Roles::Categories,   "categories"}
        , {Roles::Date,         "date"}
    };
    return mapping;
}

void RequestModel::declareInQML()
{
    TRACE();
    qmlRegisterType<RequestModel>("request_model", 1, 0, "RequestModel");
}
