#include <QDebug>
#include <QStringList>

#include "flickrmodelinterface.h"
#include "o2globals.h"

const char METHOD[] = "method";
const char URL[] = "https://api.flickr.com/services/rest";

FlickrModelInterface::FlickrModelInterface(O1Flickr *o1Flickr, QNetworkAccessManager *netManager, QString cApi, QObject *parent) :
    QObject(parent)
{
    requestor_ = new O1Requestor(netManager, o1Flickr, this);
    api = cApi;
}

FlickrModelInterface::~FlickrModelInterface()
{
    if (reply_) {
        delete reply_;
    }
    if (requestor_) {
        delete requestor_;
    }
}

void FlickrModelInterface::queryApi(const QString &params) {
    QList<O1RequestParameter> reqParams = QList<O1RequestParameter>();
    QString tmpParams(params);

    QByteArray method(METHOD);
    if (api.contains("&")) {
        QStringList lApi = api.split("&");
        reqParams << O1RequestParameter(method, lApi.at(0).toLatin1());
        tmpParams.prepend(lApi.at(1));
    } else {
        reqParams << O1RequestParameter(method, api.toLatin1());
    }

    if (!tmpParams.isEmpty()) {
        QByteArray tParam, tValue;
        QStringList lParams = tmpParams.split(":");
        QStringList::const_iterator constIterator;
        for (constIterator = lParams.constBegin(); constIterator != lParams.constEnd(); ++constIterator) {
            tParam = (*constIterator).toLatin1();
            ++constIterator;
            if (constIterator != lParams.constEnd()) {
                tValue = (*constIterator).toLatin1();
                reqParams.append(O1RequestParameter(tParam, tValue));
            }
        }
    }

    QByteArray postData = O1::createQueryParams(reqParams);

    QUrl url = QUrl(URL);

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, O2_MIME_TYPE_XFORM);

    reply_ = requestor_->post(request, reqParams, postData);
    connect(reply_, SIGNAL(finished()), this, SLOT(finished()));
}

void FlickrModelInterface::finished() {
    if (reply_->error() != QNetworkReply::NoError) {
        emit failed();
    } else {
        QByteArray xml = reply_->readAll();
        emit xmlReady(QString::fromUtf8(xml));
    }
}
