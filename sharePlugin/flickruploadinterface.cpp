#include <QDebug>
#include <QStringList>
#include <QFile>

#include "flickruploadinterface.h"
#include "o2globals.h"

const char METHOD[] = "method";
const char URL[] = "https://up.flickr.com/services/upload/";

FlickrUploadInterface::FlickrUploadInterface(QObject *parent) :
    QObject(parent), mConnStatus(FlickrUploadInterface::NotConnected)
{
    networkConnection = new NetworkConnection();
    netManager = networkConnection->getNetworkAccessManager();
    o1Flickr = new O1Flickr();
    flickrSignIn = new FlickrSignIn(o1Flickr);
    connect(flickrSignIn, SIGNAL(userLoggedInChanged()), this, SLOT(changeStatus()));

    if (networkConnection->netConnected()) {
        setConnStatus(FlickrUploadInterface::Connected);
        flickrSignIn->doOAuth();
    }

    requestor_ = new O1Requestor(netManager, o1Flickr, this);
}

FlickrUploadInterface::~FlickrUploadInterface()
{
    if (o1Flickr) {
        delete o1Flickr;
        qDebug() << "FlickrModelInterface o1Flickr deleted";
    }
    if (netManager) {
        delete netManager;
    }
//    if (networkConnection) {
//        qDebug() << "FlickrModelInterface delete networkConnection";
//        delete networkConnection;
//        qDebug() << "FlickrModelInterface networkConnection deleted";
//    }
//    if (reply_) {
//        qDebug() << "FlickrModelInterface delete reply_";
//        delete reply_;
//        qDebug() << "FlickrModelInterface reply_ deleted";
//    }
    if (requestor_) {
        delete requestor_;
    }
}

FlickrUploadInterface::FlickConnectionStatus FlickrUploadInterface::connStatus() const {
    return mConnStatus;
}

void FlickrUploadInterface::setConnStatus(FlickConnectionStatus status) {
    if (status != mConnStatus) {
        mConnStatus = status;
        emit connStatusChanged(mConnStatus);
    }
}

void FlickrUploadInterface::changeStatus() {
    switch (mConnStatus) {
    case (FlickrUploadInterface::NotConnected):
        if (networkConnection->netConnected()) {
            setConnStatus(FlickrUploadInterface::Connected);
            flickrSignIn->doOAuth();
        }
        break;
    case (FlickrUploadInterface::Connected):
        if (!networkConnection->netConnected()) {
            setConnStatus(FlickrUploadInterface::NotConnected);
        }
        else {
            if (flickrSignIn->userLoggedIn()) {
                setConnStatus(FlickrUploadInterface::Logged);
            }
            else {
                setConnStatus(FlickrUploadInterface::NotConnected);
            }
        }
        break;
    case (FlickrUploadInterface::Logged):
        if (!networkConnection->netConnected()) {
            setConnStatus(FlickrUploadInterface::NotConnected);
        }
        else {
            if (!flickrSignIn->userLoggedIn()) {
                setConnStatus(FlickrUploadInterface::NotLogged);
            }
        }
        break;
    case (FlickrUploadInterface::NotLogged):
        if (!networkConnection->netConnected()) {
            setConnStatus(FlickrUploadInterface::NotConnected);
        }
        else {
            if (flickrSignIn->userLoggedIn()) {
                setConnStatus(FlickrUploadInterface::Logged);
            }
        }
        break;
    }
}

void FlickrUploadInterface::send(const QString &mediaUrl, const QStringList &params, const QString &photosetId) {
    qDebug() << "send()";
    QUrl url = QUrl(URL);
    photosetId_ = photosetId;
    reply_ = requestor_->upload(url, params, mediaUrl);
    qDebug() << "send() started";
    emit uploadMediaStarted();
    connect(reply_, SIGNAL(finished()), this, SLOT(finished()));
    connect(reply_, SIGNAL(uploadProgress( qint64, qint64)), this, SIGNAL(uploadMediaProgress(qint64, qint64)));
}

void FlickrUploadInterface::finished() {
    if (reply_->error() != QNetworkReply::NoError) {
        QString strErr = reply_->errorString();
        QString strMesg= reply_->readAll();
        emit uploadMediaFinished(false);
    } else {
        QByteArray xml = reply_->readAll();

        emit xmlReady(QString::fromUtf8(xml));

        if (photosetId_ != "no") {
            QByteArray sPhotoId = "<photoid>";
            QByteArray fPhotoId = "</photoid>";
            int sIndexPhotoId = xml.indexOf(sPhotoId) + sPhotoId.length();
            int fIndexPhotoId = xml.indexOf(fPhotoId) - sIndexPhotoId;
            QByteArray photoId = xml.mid(sIndexPhotoId, fIndexPhotoId);;
            flickrModelInterface = new FlickrModelInterface(o1Flickr, netManager, "flickr.photosets.addPhoto", this);
            //connect(flickrModelInterface, SIGNAL(failed()), this, SIGNAL(failed()));
            connect(flickrModelInterface, SIGNAL(xmlReady(QString)), this, SLOT(photostreamAdded(QString)));
            flickrModelInterface->queryApi("photoset_id:" + photosetId_ + ":photo_id:" + photoId);
        }
        else {
            //emit xmlReady(QString::fromUtf8(xml));
            emit uploadMediaFinished(true);
        }
    }
}

void FlickrUploadInterface::photostreamAdded(QString xml) {
    emit uploadMediaFinished(true);
}
