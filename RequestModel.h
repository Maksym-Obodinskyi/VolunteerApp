#ifndef REQUESTMODEL_H
#define REQUESTMODEL_H

#include <QAbstractListModel>
#include <vector>

#include "RequestInfo.h"
#include "UserInfo.h"

class RequestModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum Roles {
          Name
        , lastName
        , Number
        , Photo
        , Email
        , Latitude
        , Longitude
        , Description
        , Title
        , Categories
        , Date

    };

    explicit RequestModel(QObject *parent = nullptr);

    static void declareInQML();

    int rowCount(const QModelIndex& parent) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

public slots:
    void updateData(std::map<int, RequestInfo> data);
    void cleanData();

private:
    std::vector<std::pair<int, RequestInfo>> _data;
};

#endif // REQUESTMODEL_H
