#include <QDebug>
#include "jockrmediatransfer.h"
#include <QStringList>

JockrMediaTransfer::JockrMediaTransfer(QObject *parent) :
    MediaTransferInterface(parent)
{
    flickrUploadInterface = new FlickrUploadInterface(this);
    connect(flickrUploadInterface, SIGNAL(uploadMediaStarted()), this, SLOT(uploadMediaStarted()));
    connect(flickrUploadInterface, SIGNAL(uploadMediaProgress(qint64,qint64)), this, SLOT(uploadMediaProgress(qint64,qint64)));
    connect(flickrUploadInterface, SIGNAL(uploadMediaFinished(bool)), this,SLOT(uploadMediaFinished(bool)));
}

JockrMediaTransfer::~JockrMediaTransfer()
{
}

QString JockrMediaTransfer::displayName() const
{
    return QString("Jockr");
}

QUrl JockrMediaTransfer::serviceIcon() const
{
    return QUrl::fromLocalFile("/usr/share/harbour-jockr/qml/pages/images/notification.png");
}

bool JockrMediaTransfer::cancelEnabled() const
{
    return false;
}

bool JockrMediaTransfer::restartEnabled() const
{
    return false;
}

void JockrMediaTransfer::start()
{
    if (flickrUploadInterface->connStatus() == FlickrUploadInterface::Logged) {
        QString url = mediaItem()->value(MediaItem::Url).toString().replace("file://", "");
        QString title = mediaItem()->value(MediaItem::Title).toString();
        QStringList descriptions = mediaItem()->value(MediaItem::Description).toString().split(",");
        QString photosetId = "no";

        if (!descriptions.isEmpty()) {
            photosetId = descriptions.takeLast();
        }

        descriptions.insert(0, title);
        QStringList::const_iterator constIterator;
//        for (constIterator = descriptions.constBegin(); constIterator != descriptions.constEnd(); ++constIterator) {
//            qDebug() << " - " << (*constIterator).toLatin1().constData();
//        }

//        QString mymeType = mediaItem()->value(MediaItem::MimeType).toString();
//        qDebug() << "mymeType: " << mymeType;

//        QString params = mediaItem()->value(MediaItem::UserData).toString();
//        qDebug() << "userData: " << params;

        flickrUploadInterface->send(url, descriptions, photosetId);
    }
    else {
        qDebug() << "Error: flickrUploadInterface->connStatus() == " << flickrUploadInterface->connStatus();
    }
}

void JockrMediaTransfer::uploadMediaStarted() {
    setStatus(MediaTransferInterface::TransferStarted);
}

void JockrMediaTransfer::cancel() {
    setStatus(MediaTransferInterface::TransferCanceled);
}

void JockrMediaTransfer::uploadMediaProgress(qint64 bytesSent, qint64 bytesTotal) {
    qreal percent;
    if (bytesTotal != -1) {
        percent = qRound((qreal)bytesSent / (qreal)bytesTotal);
        setProgress(percent);
    } else {
        setStatus(MediaTransferInterface::NotStarted);
    }
}

void JockrMediaTransfer::uploadMediaFinished(bool ok) {
    if (ok) {
        setStatus(MediaTransferInterface::TransferFinished);
    } else {
        setStatus(MediaTransferInterface::TransferInterrupted);
    }
}
