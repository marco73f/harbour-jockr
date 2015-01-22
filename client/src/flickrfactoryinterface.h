#ifndef FLICKRFACTORYINTERFACE_H
#define FLICKRFACTORYINTERFACE_H

#include <QObject>
#include <QNetworkAccessManager>

#include "o1flickr.h"
#include "flickrmodelinterface.h"

class FlickrFactoryInterface : public QObject
{
    Q_OBJECT
public:
    explicit FlickrFactoryInterface(O1Flickr *o1Flickr, QNetworkAccessManager *netManager, QObject *parent = 0);
    ~FlickrFactoryInterface();

    Q_INVOKABLE QObject* getModelInterface(QString api);

private:
    O1Flickr *o1Flickr_;
    QNetworkAccessManager *netManager_;
    QHash<QString, FlickrModelInterface*> *hModelInterface;
};

#endif // FLICKRFACTORYINTERFACE_H
