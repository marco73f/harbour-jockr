#ifndef FLICKRMODELINTERFACE_H
#define FLICKRMODELINTERFACE_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>

#include "o1flickr.h"
#include "o1requestor.h"

class FlickrModelInterface : public QObject
{
    Q_OBJECT
public:
    explicit FlickrModelInterface(O1Flickr *o1Flickr, QNetworkAccessManager *netManager, QString cApi, QObject *parent = 0);
    ~FlickrModelInterface();

signals:
    void xmlReady(QString xmlResponse);
    void failed();

public slots:
    void queryApi(const QString &params);

private slots:
    void finished();

private:
    QNetworkReply *reply_;
    O1Requestor *requestor_;
    QString api;
};
#endif // FLICKRMODELINTERFACE_H
