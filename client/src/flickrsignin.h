#ifndef FLICKRSIGNIN_H
#define FLICKRSIGNIN_H

#include <QObject>
#include <QVariantMap>
#include <QNetworkReply>
#include <QSettings>

#include "o1flickr.h"
#include "oxflickr.h"
#include "o2settingsstore.h"

class FlickrSignIn : public QObject
{
    Q_OBJECT
    Q_PROPERTY (bool userLoggedIn READ userLoggedIn WRITE setUserLoggedIn NOTIFY userLoggedInChanged)
    Q_PROPERTY (QString fullname READ fullname WRITE setFullname NOTIFY fullnameChanged)
    Q_PROPERTY (QString nsid READ nsid WRITE setNsid NOTIFY nsidChanged)
    Q_PROPERTY (QString username READ username WRITE setUsername NOTIFY usernameChanged)

public:
    explicit FlickrSignIn(O1Flickr* o1Flickr, QObject *parent = 0);

    bool userLoggedIn() const;
    QString fullname() const;
    QString nsid() const;
    QString username() const;

    void setUserLoggedIn(bool val);
    void setFullname(const QString &val);
    void setNsid(const QString &val);
    void setUsername(const QString &val);

    Q_INVOKABLE void doOAuth();
    Q_INVOKABLE void disconnect();

signals:
    void extraTokensReady(const QVariantMap &extraTokens);
    void linkingFailed();
    void linkingSucceeded();
    void userLoggedInChanged();
    void fullnameChanged();
    void nsidChanged();
    void usernameChanged();
    void openAuthorizeWebPage(const QUrl &url);
    void openSignOutWebPage(const QUrl &url);

private slots:
    void onLinkingFailed();
    void onLinkingSucceeded();
    void replyFinished(QNetworkReply*);

private:
    O1Flickr* o1Flickr_;
    bool m_userLoggedIn;
    QString m_fullname;
    QString m_nsid;
    QString m_username;
    O2SettingsStore* store;
    QSettings* m_qsettings;
};

#endif // FLICKRSIGNIN_H
