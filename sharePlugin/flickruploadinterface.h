#ifndef FLICKRUPLOADINTERFACE_H
#define FLICKRUPLOADINTERFACE_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QHttpMultiPart>
#include <QHttpPart>

#include "networkconnection.h"
#include "o1flickr.h"
#include "flickrsignin.h"
#include "o1requestor.h"

class FlickrUploadInterface : public QObject
{
    Q_OBJECT
    Q_PROPERTY (FlickConnectionStatus connStatus READ connStatus WRITE setConnStatus NOTIFY connStatusChanged)

public:
    enum FlickConnectionStatus {
        NotConnected,
        Connected,
        NotLogged,
        Logged
    };

    explicit FlickrUploadInterface(QObject *parent = 0);
    ~FlickrUploadInterface();

    FlickConnectionStatus connStatus() const;
    void setConnStatus(FlickConnectionStatus status);

signals:
    void xmlReady(QString xmlResponse);
    void failed();
    void connStatusChanged(FlickConnectionStatus status);
    void uploadMediaStarted();
    void uploadMediaProgress(qint64 bytesSent, qint64 bytesTotal);
    void uploadMediaFinished(bool ok);

public slots:
    void send(const QString &mediaUrl, const QStringList &params);

private slots:
    void finished();
    void changeStatus();

private:
    QByteArray generateBoundary();
    QHttpPart constructField(const QString name, const QByteArray content);

    QNetworkReply *reply_;
    O1Requestor *requestor_;
    O1Flickr *o1Flickr;
    FlickrSignIn *flickrSignIn;
    NetworkConnection *networkConnection;
    QNetworkAccessManager *netManager;
    FlickConnectionStatus mConnStatus;
};

#endif // FLICKRUPLOADINTERFACE_H
