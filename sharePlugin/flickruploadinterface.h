#ifndef FLICKRUPLOADINTERFACE_H
#define FLICKRUPLOADINTERFACE_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>

#include "networkconnection.h"
#include "o1flickr.h"
#include "flickrsignin.h"
#include "o1requestor.h"
#include "flickrmodelinterface.h"

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
    void send(const QString &mediaUrl, const QStringList &params, const QString &photosetId);

private slots:
    void finished();
    void changeStatus();
    void photostreamAdded(QString xml);

private:
    QNetworkReply *reply_;
    O1Requestor *requestor_;
    O1Flickr *o1Flickr;
    FlickrSignIn *flickrSignIn;
    NetworkConnection *networkConnection;
    QNetworkAccessManager *netManager;
    FlickConnectionStatus mConnStatus;
    FlickrModelInterface *flickrModelInterface;
    QString photosetId_;
};

#endif // FLICKRUPLOADINTERFACE_H
