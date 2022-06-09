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
          , std::string _description
          , std::string _title
          , std::set<std::string> _categories
          , int _date);
    Request() : QObject(nullptr) {}
    Request(const Request & req);
    Request(Request && req);
    Request& operator=(const Request & req);
    Request& operator=(Request && req);

    static void declareInQML();

    Q_PROPERTY(double latitude READ getLatitude)
    Q_PROPERTY(double longitude READ getLongitude)

    double getLatitude();
    double getLongitude();

    std::pair<double, double> location;
    std::string description;
    std::string title;
    std::set<std::string> categories;
    int date;
};

Q_DECLARE_METATYPE(Request);

#endif // REQUEST_H
