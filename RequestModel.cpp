#define LOG_CATEGORY "RequestModel"
#include "Logger.h"

#include "RequestModel.h"

RequestModel::RequestModel(QObject *parent) : QAbstractListModel(parent)
{
    TRACE();
}

void RequestModel::updateData()
{
    TRACE();
}
