#include <QDebug>

#include "flickrfactoryinterface.h"
#include "o2globals.h"

const char METHOD[] = "method";

FlickrFactoryInterface::FlickrFactoryInterface(O1Flickr *o1Flickr, QNetworkAccessManager *netManager, QObject *parent) :
    QObject(parent)
{
    o1Flickr_ = o1Flickr;
    netManager_ = netManager;
    hModelInterface = new QHash<QString, FlickrModelInterface*>;
}

FlickrFactoryInterface::~FlickrFactoryInterface()
{
    delete hModelInterface;
}

QObject* FlickrFactoryInterface::getModelInterface(QString api) {
    FlickrModelInterface* iModel = hModelInterface->value(api, 0);

    if (!iModel) {
        hModelInterface->insert(api,
            iModel = new FlickrModelInterface(o1Flickr_, netManager_, api, this));
    }

    return iModel;
}
