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
    }
    if (networkConnection) {
        delete networkConnection;
    }
    if (netManager) {
        delete netManager;
    }
    if (reply_) {
        delete reply_;
    }
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

QByteArray FlickrUploadInterface::generateBoundary() {
    const int lenght = 15;
    QChar unicode[lenght];
    for (int i = 0; i < lenght; ++i)
    {
        int sel = qrand() % 2;
        int temp = (sel) ? qrand() % 9 + 49 : qrand() % 23 + 98;
        unicode[i] = QChar(temp);
    }

    int size = sizeof(unicode) / sizeof (QChar);
    QString str = QString::fromRawData(unicode, size);

    return str.toLatin1();
}

void FlickrUploadInterface::send(const QString &mediaUrl, const QStringList &params) {
    QUrl url(URL);
    QNetworkRequest request(url);

    QList<O1RequestParameter> signingParameters = QList<O1RequestParameter>();
    QMap<QString,QByteArray> map;

    if (!params.isEmpty()) {
        QString tValue;
        QStringList tParam;
        tParam << "title" << "description" << "tags" << "mediaType" << "is_friend" << "is_family" << "is_public" << "safety_level" << "hidden";
        int tIndex = 0;
        QStringList::const_iterator constIterator;
        for (constIterator = params.constBegin(); constIterator != params.constEnd(); ++constIterator) {
            tValue = (*constIterator);
            if (tParam.at(tIndex).toLatin1() != "photo" && tParam.at(tIndex).toLatin1() != "filename" && tParam.at(tIndex).toLatin1() != "filemimetype") {
                signingParameters.append(O1RequestParameter(tParam.at(tIndex).toLatin1(), tValue.toLatin1()));
            }
            map.insert(tParam.at(tIndex), tValue.toLatin1());
            tIndex++;
        }
    }

    QMapIterator<QString, QByteArray> i(map);
    QStringList keyList;
    while(i.hasNext())
    {
        i.next();
        keyList << i.key();
    }
    qSort(keyList.begin(), keyList.end());

    QHttpMultiPart *multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);

    for (int i = 0; i < keyList.size(); ++i)
    {
        multiPart->append(constructField(keyList.at(i), map.value(keyList.at(i))));
    }

    QHttpPart imagePart;
    imagePart.setHeader(QNetworkRequest::ContentTypeHeader, QVariant("image/jpeg"));
    imagePart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"photo\""));
    QFile *file = new QFile(mediaUrl);
    file->open(QIODevice::ReadOnly);
    imagePart.setBodyDevice(file);
    file->setParent(multiPart);

    reply_ = requestor_->post(request, signingParameters, multiPart);
    emit uploadMediaStarted();
    connect(reply_, SIGNAL(finished()), this, SLOT(finished()));
    connect(reply_, SIGNAL(uploadProgress( qint64, qint64)), this, SIGNAL(uploadMediaProgress(qint64, qint64)));
}

QHttpPart FlickrUploadInterface::constructField(const QString name, const QByteArray content) {
    QHttpPart textPart;
    textPart.setHeader(QNetworkRequest::ContentTypeHeader, QVariant("text/plain"));
    textPart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"" + name + "\""));
    textPart.setBody(content);
    return textPart;
}

void FlickrUploadInterface::finished() {
    if (reply_->error() != QNetworkReply::NoError) {
        QString strErr = reply_->errorString();
        QString strMesg= reply_->readAll();
        emit uploadMediaFinished(false);
    } else {
        QByteArray xml = reply_->readAll();
        emit xmlReady(QString::fromUtf8(xml));
        emit uploadMediaFinished(true);
    }
}
