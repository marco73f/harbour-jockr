#ifndef JOCKRSETTINGS_H
#define JOCKRSETTINGS_H

#include "simplecrypt.h"

#include <QObject>
#include <QSettings>

class JockrSettings : public QObject
{
    Q_OBJECT
public:
    explicit JockrSettings(QObject *parent = 0);
    ~JockrSettings();

signals:

public slots:
    void load();
    void remove();
    QString xmlAlbumList();
    void setXmlAlbumList(const QString &xmlAlbumList);

private:
    QSettings *qSettings;
    QString _xmlAlbumList;
    SimpleCrypt *crypto;
};

#endif // JOCKRSETTINGS_H
