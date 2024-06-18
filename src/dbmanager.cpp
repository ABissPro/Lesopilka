#include "dbmanager.h"

//DbManager::DbManager()

#include <QFile>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QDebug>


dbmanager::dbmanager(QObject *parent) : QObject(parent) {}

bool dbmanager::initializeDatabase(const QString &dbName) {
    fileName = dbName + ".txt";

    QFile file(fileName);
    if (!file.open(QIODevice::ReadWrite)) {
        qDebug() << "Error: unable to open file" << file.errorString();
        return false;
    }

    QByteArray fileData = file.readAll();
    QJsonDocument doc(QJsonDocument::fromJson(fileData));
    if (!doc.isNull()) {
        data = doc.array();
    } else {
        data = QJsonArray();
    }

    file.close();
    return true;
}

bool dbmanager::saveDiameterAndHeight(double diameter, double height) {
    QJsonObject tree;
    tree["diameter"] = diameter;
    tree["height"] = height;
    data.append(tree);

    QFile file(fileName);
    if (!file.open(QIODevice::WriteOnly)) {
        qDebug() << "Error: unable to open file" << file.errorString();
        return false;
    }

    QJsonDocument doc(data);
    file.write(doc.toJson());
    file.close();

    return true;
}

bool dbmanager::saveBreed(const QString &breed) {
    if (data.isEmpty()) {
        qDebug() << "Error: no data to update";
        return false;
    }

    QJsonObject lastTree = data.last().toObject();
    lastTree["breed"] = breed;
    data[data.size() - 1] = lastTree;

    QFile file(fileName);
    if (!file.open(QIODevice::WriteOnly)) {
        qDebug() << "Error: unable to open file" << file.errorString();
        return false;
    }

    QJsonDocument doc(data);
    file.write(doc.toJson());
    file.close();

    return true;
}

bool dbmanager::readData() {
    QFile file(fileName);
    if (!file.open(QIODevice::ReadOnly)) {
        qDebug() << "Error: unable to open file" << file.errorString();
        return false;
    }

    QByteArray fileData = file.readAll();
    QJsonDocument doc(QJsonDocument::fromJson(fileData));
    if (doc.isNull()) {
        qDebug() << "Error: unable to parse JSON";
        return false;
    }

    data = doc.array();
    for (const QJsonValue &value : data) {
        QJsonObject obj = value.toObject();
        qDebug() << "ID:" << obj["id"].toInt() << "Breed:" << obj["breed"].toString()
                 << "Diameter:" << obj["diameter"].toDouble() << "Height:" << obj["height"].toDouble();
    }

    file.close();
    return true;
}

