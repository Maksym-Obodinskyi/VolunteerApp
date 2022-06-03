#ifndef REQUESTMODEL_H
#define REQUESTMODEL_H

#include <QAbstractListModel>
#include <vector>

#include "Request.h"
#include "User.h"

class RequestModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum Roles {
          Name
        , lastName
        , Number
        , Photo
        , Rating
        , Location
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
    void updateData(std::map<int, std::pair<Request, User>> data);
private:
    std::vector<std::tuple<int, Request, User>> _data;
};

#endif // REQUESTMODEL_H
