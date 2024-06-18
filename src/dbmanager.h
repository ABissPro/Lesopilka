#ifndef DBMANAGER_H
#define DBMANAGER_H
#include <QObject>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>

class dbmanager : public QObject
{
    Q_OBJECT
public:
    explicit dbmanager(QObject *parent = nullptr);
    bool initializeDatabase(const QString &dbName);
    bool saveDiameterAndHeight(double diameter, double height);
    bool saveBreed(const QString &breed);
    bool readData();

private:
    QString fileName;
    QJsonArray data;
};

#endif
