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
    connect(&SessionManager::instance(),    SIGNAL(updateData(std::map<int, std::pair<Request, User>>)),
            this,                           SLOT(updateData(std::map<int, std::pair<Request, User>>)));
    connect(&ConfigManager::instance(),     SIGNAL(updateData(std::map<int, std::pair<Request, User>>)),
            this,                           SLOT(updateData(std::map<int, std::pair<Request, User>>)));
    connect(&RequestController::instance(), SIGNAL(cleanModel()),
            this,                           SLOT(cleanData()));
}

void RequestModel::updateData(std::map<int, std::pair<Request, User>> data)
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
        _data.push_back(std::make_tuple(time, item.first, item.second));
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

    const auto & [time, req, user] = _data[index.row()];

    switch (role) {
        case Name:          return user.name.c_str();
        case lastName:      return user.lastName.c_str();
        case Number:        return user.number.c_str();
        case Photo:         return user.photo.c_str();
        case Rating:        return user.rating;
        case Description:   return req.description.c_str();
        case Title:         return req.title.c_str();
        case Date:          return req.date;
        case Categories:
        case Location:
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
        , {Roles::Rating,       "rating"}
        , {Roles::Location,     "location"}
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
