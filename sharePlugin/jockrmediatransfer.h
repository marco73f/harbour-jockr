#ifndef JOCKRMEDIATRANSFER_H
#define JOCKRMEDIATRANSFER_H

#include <QObject>
#include <TransferEngine-qt5/mediatransferinterface.h>
#include <TransferEngine-qt5/mediaitem.h>

#include "flickruploadinterface.h"

class JockrMediaTransfer : public MediaTransferInterface
{
    Q_OBJECT
public:
    JockrMediaTransfer(QObject * parent = 0);
    ~JockrMediaTransfer();

    QString	displayName() const;
    QUrl	serviceIcon() const;
    bool	cancelEnabled() const;
    bool	restartEnabled() const;

private slots:
    void uploadMediaStarted();
    void uploadMediaProgress(qint64 bytesSent, qint64 bytesTotal);
    void uploadMediaFinished(bool ok);

public slots:
    void cancel();
    void start();

private:
    FlickrUploadInterface *flickrUploadInterface;
};

#endif // JOCKRMEDIATRANSFER_H
