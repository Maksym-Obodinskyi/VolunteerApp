#ifndef REQUESTMODEL_H
#define REQUESTMODEL_H

#include <QAbstractListModel>
#include <set>

#include "Request.h"

class RequestModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit RequestModel(QObject *parent = nullptr);

    static void declareInQML();

public slots:
    void updateData();
private:
    std::set<Request> _requests;
};

#endif // REQUESTMODEL_H
