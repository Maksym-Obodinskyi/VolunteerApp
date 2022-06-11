#ifndef REQUEST_H
#define REQUEST_H
#include <string>
#include <set>
#include <QObject>

struct Request : public QObject
{
    Q_GADGET
public:
    Request(std::pair<double, double> _location
          , const std::string & _description
          , const std::string & _title
          , const std::string & _categories
          , int _date);
    Request() : QObject(nullptr) {}
    Request(const Request & req);
    Request(Request && req);
    Request& operator=(const Request & req);
    Request& operator=(Request && req);

    static void declareInQML();

    Q_PROPERTY(double latitude READ getLatitude)
    Q_PROPERTY(double longitude READ getLongitude)
    Q_PROPERTY(QString title READ getTitle)
    Q_PROPERTY(QString description READ getDescription)
    Q_PROPERTY(QString categories READ getCategories)
    Q_PROPERTY(int date READ getDate)

    double getLatitude();
    double getLongitude();
    QString getDescription();
    QString getTitle();
    QString getCategories();
    int getDate();

    std::pair<double, double> location;
    std::string description;
    std::string title;
    std::string categories;
    int date;
};

Q_DECLARE_METATYPE(Request);

#endif // REQUEST_H
