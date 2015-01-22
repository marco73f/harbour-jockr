#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QDesktopServices>
#include <QDebug>

#include "flickrsignin.h"
#include "o2globals.h"

const char O2_CONSUMER_KEY[] = "cca59ba875da357d418e52b8b8d17804";
const char O2_CONSUMER_SECRET[] = "e4ef6fd532ffde25";
const char STORE_ORGANIZATION[] = "marco73f";
const char STORE_APPLICATION[] = "harbour-jockr";
const char STORE_GROUP_KEY[] = "jockr";
const int localPort = 8888;

FlickrSignIn::FlickrSignIn(O1Flickr* o1Flickr, QObject *parent) :
    o1Flickr_(o1Flickr),
    QObject(parent),
    m_userLoggedIn(false)
{
    o1Flickr_->setClientId(O2_CONSUMER_KEY);
    o1Flickr_->setClientSecret(O2_CONSUMER_SECRET);
    o1Flickr_->setLocalPort(localPort);
    m_qsettings = new QSettings(STORE_ORGANIZATION, STORE_APPLICATION);
    store = new O2SettingsStore(m_qsettings, O2_ENCRYPTION_KEY, this);
    o1Flickr_->setStore(store);
    connect(o1Flickr_, SIGNAL(openBrowser(QUrl)),
            this, SIGNAL(openAuthorizeWebPage(QUrl)));
    connect(o1Flickr_, SIGNAL(linkingFailed()),
            this, SLOT(onLinkingFailed()));
    connect(o1Flickr_, SIGNAL(linkingSucceeded()),
            this, SLOT(onLinkingSucceeded()));
}

bool FlickrSignIn::userLoggedIn() const {
    return m_userLoggedIn;
}

QString FlickrSignIn::fullname() const {
    return m_fullname;
}

QString FlickrSignIn::nsid() const {
    return m_nsid;
}

QString FlickrSignIn::username() const {
    return m_username;
}

void FlickrSignIn::setUserLoggedIn(bool val) {
    if (val != m_userLoggedIn) {
        m_userLoggedIn = val;
        emit userLoggedInChanged();
    }
}

void FlickrSignIn::setFullname(const QString &val) {
    if (val != m_fullname) {
        m_fullname = val;
        emit fullnameChanged();
    }
}

void FlickrSignIn::setNsid(const QString &val) {
    if (val != m_nsid) {
        m_nsid = val;
        emit nsidChanged();
    }
}

void FlickrSignIn::setUsername(const QString &val) {
    if (val != m_username) {
        m_username = val;
        emit usernameChanged();
    }
}


void FlickrSignIn::doOAuth() {
    if (o1Flickr_->linked()) {
        onLinkingSucceeded();
    } else {
        o1Flickr_->link();
    }
}

void FlickrSignIn::disconnect() {
    QString key;
    QStringList keys = m_qsettings->allKeys();
    QStringList::const_iterator constIterator;
    for (constIterator = keys.constBegin(); constIterator != keys.constEnd(); ++constIterator) {
        key = *constIterator;
        m_qsettings->remove(key);
    }

    setUserLoggedIn(false);
    setFullname("");
    setNsid("");
    setUsername("");
    emit openSignOutWebPage(QUrl("https://www.flickr.com/logout.gne"));
}

void FlickrSignIn::replyFinished(QNetworkReply* reply) {
    QByteArray flickrResponce = reply->readAll();
    int startIndex = flickrResponce.indexOf("logout.gne?magic_cookie=");
    if (startIndex > 0) {
        QUrl url("https://www.flickr.com/" + flickrResponce.mid(startIndex, 88));
        emit openSignOutWebPage(url);
    }
    else {
        emit openSignOutWebPage(QUrl("https://www.flickr.com/logout.gne"));
    }
}

void FlickrSignIn::onLinkingFailed() {
    setUserLoggedIn(false);
}

void FlickrSignIn::onLinkingSucceeded() {
    QVariantMap extraTokens = o1Flickr_->extraTokens();


    if (!extraTokens.isEmpty()) {
        emit extraTokensReady(extraTokens);

        foreach (QString key, extraTokens.keys()) {
            if (QString::compare(key, "fullname") == 0) {
                setFullname(extraTokens.value(key).toString());
            } else {
                if (QString::compare(key, "user_nsid") == 0) {
                    setNsid(extraTokens.value(key).toString());
                    m_qsettings->setValue("nsid", extraTokens.value(key).toString());
                } else {
                    if (QString::compare(key, "username") == 0) {
                        setUsername(extraTokens.value(key).toString());
                    }
                }

            }
        }
    }
    else {
        setNsid(m_qsettings->value("nsid").toString());
    }
    emit linkingSucceeded();
    setUserLoggedIn(true);
}
