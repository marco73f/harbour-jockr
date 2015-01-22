#ifndef OXFLICKR_H
#define OXFLICKR_H

#include "o1flickr.h"

class OXFlickr: public O1Flickr {
    Q_OBJECT

public:
    explicit OXFlickr(QObject *parent = 0);
    /// Flickr XAuth login parameters
    /// XAuth Username
    Q_PROPERTY(QString username READ username WRITE setUsername NOTIFY usernameChanged)
    QString username();
    void setUsername(const QString &username);

    /// XAuth Password
    Q_PROPERTY(QString password READ password WRITE setPassword NOTIFY passwordChanged)
    QString password();
    void setPassword(const QString &username);

public slots:
    /// Authenticate.
    Q_INVOKABLE virtual void link();

signals:
    void usernameChanged();
    void passwordChanged();

private:
    QList<O1RequestParameter> xAuthParams_;
    QString username_;
    QString password_;
};

#endif // OXFLICKR_H
