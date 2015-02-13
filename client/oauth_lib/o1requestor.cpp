#include <QDebug>
#include <QTimer>
#include <QDateTime>
#include <QNetworkReply>
#include <QNetworkAccessManager>
#include <QDataStream>
#include <QStringList>
#include <QFile>
#include <QIODevice>
#include <QBuffer>

#include "o1requestor.h"
#include "o2globals.h"

/// A timer connected to a network reply.
class TimedReply: public QTimer {
    Q_OBJECT

public:
    explicit TimedReply(QNetworkReply *parent): QTimer(parent) {
        setSingleShot(true);
        setInterval(60 * 1000); // FIXME: Expose me
        connect(this, SIGNAL(error(QNetworkReply::NetworkError)), parent, SIGNAL(error(QNetworkReply::NetworkError)));
        connect(this, SIGNAL(timeout()), this, SLOT(onTimeout()));
    }

signals:
    void error(QNetworkReply::NetworkError);

public slots:
    void onTimeout() {emit error(QNetworkReply::TimeoutError);}
};

O1Requestor::O1Requestor(QNetworkAccessManager *manager, O1 *authenticator, QObject *parent): QObject(parent) {
    manager_ = manager;
    authenticator_ = authenticator;
}

QNetworkReply *O1Requestor::get(const QNetworkRequest &req, const QList<O1RequestParameter> &signingParameters) {
    QNetworkRequest request = setup(req, signingParameters, QNetworkAccessManager::GetOperation);
    return addTimer(manager_->get(request));
}

QNetworkReply *O1Requestor::post(const QNetworkRequest &req, const QList<O1RequestParameter> &signingParameters, const QByteArray &data) {
    QNetworkRequest request = setup(req, signingParameters, QNetworkAccessManager::PostOperation);
    return addTimer(manager_->post(request, data));
}

QNetworkReply *O1Requestor::upload(const QUrl &url, const QStringList &params, const QString &mediaUrl) {
    QByteArray payload;
    QByteArray boundary = generateBoundary();
    QNetworkRequest req(url);
    req.setRawHeader("Content-Type", "multipart/form-data; boundary=" + boundary);
    QList<O1RequestParameter> signingParameters = QList<O1RequestParameter>();
    QMap<QString,QString> map;


    if (!params.isEmpty()) {
        QString tValue;
        QStringList tParam;
        tParam << "title" << "description" << "tags" << "mediaType" << "is_friend" << "is_family" << "is_public" << "safety_level" << "hidden";
        int tIndex = 0;
        QStringList::const_iterator constIterator;
        for (constIterator = params.constBegin(); constIterator != params.constEnd(); ++constIterator) {
            tValue = (*constIterator);
            qDebug() << "#### tParam: " << tParam.at(tIndex) << " tValue: " << tValue;
            if (tParam.at(tIndex).toLatin1() != "photo" && tParam.at(tIndex).toLatin1() != "filename" && tParam.at(tIndex).toLatin1() != "filemimetype") {
                signingParameters.append(O1RequestParameter(tParam.at(tIndex).toLatin1(), tValue.toLatin1()));
            }
            map.insert(tParam.at(tIndex), tValue);
            tIndex++;
        }
    }


    QList<O1RequestParameter> oauthParams;
    oauthParams.append(O1RequestParameter(O2_OAUTH_CONSUMER_KEY, authenticator_->clientId().toLatin1()));
    map.insert(O2_OAUTH_CONSUMER_KEY, authenticator_->clientId());
    oauthParams.append(O1RequestParameter(O2_OAUTH_VERSION, "1.0"));
    map.insert(O2_OAUTH_VERSION, "1.0");
    oauthParams.append(O1RequestParameter(O2_OAUTH_TOKEN, authenticator_->token().toLatin1()));
    map.insert(O2_OAUTH_TOKEN, authenticator_->token());
    oauthParams.append(O1RequestParameter(O2_OAUTH_SIGNATURE_METHOD, O2_SIGNATURE_TYPE_HMAC_SHA1));
    map.insert(O2_OAUTH_SIGNATURE_METHOD, O2_SIGNATURE_TYPE_HMAC_SHA1);
    oauthParams.append(O1RequestParameter(O2_OAUTH_NONCE, O1::nonce()));
    map.insert(O2_OAUTH_NONCE, O1::nonce());
    oauthParams.append(O1RequestParameter(O2_OAUTH_TIMESTAMP, QString::number(QDateTime::currentDateTimeUtc().toTime_t()).toLatin1()));
    map.insert(O2_OAUTH_TIMESTAMP, QString::number(QDateTime::currentDateTimeUtc().toTime_t()));
    QByteArray signature = authenticator_->sign(oauthParams, signingParameters, req.url(), QNetworkAccessManager::PostOperation, authenticator_->clientSecret(), authenticator_->tokenSecret());
    oauthParams.append(O1RequestParameter(O2_OAUTH_SIGNATURE, signature));
    map.insert(O2_OAUTH_SIGNATURE, QString(signature));

    QMapIterator<QString, QString> i(map);
    QStringList keyList;
    while(i.hasNext())
    {
        i.next();
        keyList << i.key();
    }
    qSort(keyList.begin(), keyList.end());

    for (int i = 0; i < keyList.size(); ++i)
    {
        payload.append(constructField(keyList.at(i), map.value(keyList.at(i)), boundary, ""));
    }

    payload.append(constructField("photo", "", boundary, "image.jpg"));

    QFile file(mediaUrl);
    file.open(QIODevice::ReadOnly);
    payload.append(file.readAll());
    file.close();

    payload.append("\r\n--");
    payload.append(boundary);
    payload.append("--\r\n\r\n");

    qDebug() << "5 - payload: " << payload << " payload.size: " << payload.size();

    return addTimer(manager_->post(req, payload));

}


//QNetworkReply *O1Requestor::upload(const QUrl &url, const QStringList &params, const QString &mediaUrl) {
//    QByteArray payload;
//    QDataStream dataStream(&payload, QIODevice::WriteOnly);
//    QByteArray boundary = generateBoundary();
//    QNetworkRequest req(url);
//    req.setRawHeader("Content-Type", "multipart/form-data; boundary=" + boundary);
//    //req.setRawHeader("Host", "up.flickr.com");
//    QList<O1RequestParameter> signingParameters = QList<O1RequestParameter>();
//    QMap<QString,QString> map;

//    /*
//    if (!params.isEmpty()) {
//        QString tValue;
//        QStringList tParam;
//        tParam << "description" << "tags" << "mediaType" << "is_friend" << "is_family" << "is_public" << "safety_level" << "hidden";
//        int tIndex = 0;
//        QStringList::const_iterator constIterator;
//        for (constIterator = params.constBegin(); constIterator != params.constEnd(); ++constIterator) {
//            tValue = (*constIterator);
//            qDebug() << "#### tParam: " << tParam.at(tIndex) << " tValue: " << tValue;
//            signingParameters.append(O1RequestParameter(tParam.at(tIndex).toLatin1(), tValue.toLatin1()));
//            map.insert(tParam.at(tIndex), tValue);
//            tIndex++;
//        }
//    }
//    */

//    QList<O1RequestParameter> oauthParams;
//    oauthParams.append(O1RequestParameter(O2_OAUTH_CONSUMER_KEY, authenticator_->clientId().toLatin1()));
//    map.insert(O2_OAUTH_CONSUMER_KEY, authenticator_->clientId());
//    oauthParams.append(O1RequestParameter(O2_OAUTH_VERSION, "1.0"));
//    map.insert(O2_OAUTH_VERSION, "1.0");
//    oauthParams.append(O1RequestParameter(O2_OAUTH_TOKEN, authenticator_->token().toLatin1()));
//    map.insert(O2_OAUTH_TOKEN, authenticator_->token());
//    oauthParams.append(O1RequestParameter(O2_OAUTH_SIGNATURE_METHOD, O2_SIGNATURE_TYPE_HMAC_SHA1));
//    map.insert(O2_OAUTH_SIGNATURE_METHOD, O2_SIGNATURE_TYPE_HMAC_SHA1);
//    oauthParams.append(O1RequestParameter(O2_OAUTH_NONCE, O1::nonce()));
//    map.insert(O2_OAUTH_NONCE, O1::nonce());
//    oauthParams.append(O1RequestParameter(O2_OAUTH_TIMESTAMP, QString::number(QDateTime::currentDateTimeUtc().toTime_t()).toLatin1()));
//    map.insert(O2_OAUTH_TIMESTAMP, QString::number(QDateTime::currentDateTimeUtc().toTime_t()));
////    oauthParams.append(O1RequestParameter(O2_OAUTH_TOKEN_SECRET, authenticator_->tokenSecret().toLatin1()));
////    map.insert(O2_OAUTH_TOKEN_SECRET, authenticator_->tokenSecret());
//    // Add signature parameter
//    QByteArray signature = authenticator_->sign(oauthParams, signingParameters, req.url(), QNetworkAccessManager::PostOperation, authenticator_->clientSecret(), authenticator_->tokenSecret());
//    //oauthParams.append(O1RequestParameter(O2_OAUTH_SIGNATURE, signature));
//    //map.insert(O2_OAUTH_SIGNATURE, QString(signature));
//    //req.setRawHeader(O2_HTTP_AUTHORIZATION_HEADER, O1::buildAuthorizationHeader(oauthParams));

//    QMapIterator<QString, QString> i(map);
//    QStringList keyList;
//    while(i.hasNext())
//    {
//        i.next();
//        keyList << i.key();
//    }
//    qSort(keyList.begin(), keyList.end());

//    //QString apiSig(authenticator_->clientSecret());

//    for (int i = 0; i < keyList.size(); ++i)
//    {
//        //apiSig.append(keyList.at(i) + map.value(keyList.at(i)));

//        QByteArray field = constructField(keyList.at(i), map.value(keyList.at(i)), boundary, "");
//        dataStream.writeRawData(field.data(), field.length());
//        //signingParameters.append(O1RequestParameter(keyList.at(i).toLatin1(), map.value(keyList.at(i)).toLatin1()));
//    }
//    //apiSig = md5(apiSig);
//    //apiSig = hmacSha1(apiSig);

//    //QNetworkRequest request = setup(req, signingParameters, QNetworkAccessManager::PostOperation);

//    //QByteArray sigField = constructField("api_sig", apiSig, boundary, "");
//    QByteArray sigField = constructField(O2_OAUTH_SIGNATURE, signature, boundary, "");
//    dataStream.writeRawData(sigField.data(), sigField.length());

//    //QByteArray fileField = constructField("photo", "", boundary, mediaUrl);
//    QByteArray fileField = constructField("photo", "", boundary, "provaJockr");
//    dataStream.writeRawData(fileField.data(), fileField.length());

////    QFile file(mediaUrl);
////    file.open(QIODevice::ReadOnly);
////    QByteArray line;
////    int iByte = 1;
////    int retDataStream;
////    while(!file.atEnd()) {
////        line = file.readLine();
////        retDataStream = dataStream.writeRawData(line.data(), line.length());
////        qDebug() << " dataStream.status = " << dataStream.status() << " retDataStream = " << retDataStream;
////    }
//    QFile file(mediaUrl);
//    file.open(QIODevice::ReadOnly);
//    QByteArray line = file.readAll();
//    dataStream.writeRawData(line.data(), line.length());
//    qDebug() << "line.length() = " << line.length();
//    file.close();

//    QByteArray endField;
//    endField.append("\r\n--");
//    endField.append(boundary);
//    endField.append("--\r\n\r\n");
//    dataStream.writeRawData(endField.data(), endField.length());
//    //qDebug() << " dataStream.status = " << dataStream.status() << " retDataStream = " << retDataStream;

//    qDebug() << "5 - payload: " << payload;

//    req.setRawHeader("Content-Length", QString::number(payload.length()).toLatin1());

//    qDebug() << "6 - Content-Length : " << payload.length();
//    file.close();


//    return addTimer(manager_->post(req, payload));
//}

QByteArray O1Requestor::generateBoundary() {
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

QByteArray O1Requestor::constructField(const QString name, const QString content, const QByteArray boundary, QString filename) {
    QByteArray data;
    data.append("--");
    data.append(boundary);
    data.append("\r\n");
    data.append("Content-Disposition: form-data; name=\"");
    data.append(name);
    if (filename.isEmpty()) {
        data.append("\"\r\n\r\n");
        data.append(content);
        data.append("\r\n");
    }
    else {
        data.append("\"; filename=\"");
        data.append(filename);
        data.append("\";\r\n");
        data.append("Content-Type: image/jpeg\r\n\r\n");
    }

    return data;
}

QString O1Requestor::md5(const QString &data) {
    QString hash(QCryptographicHash::hash(data.toLatin1(), QCryptographicHash::Md5).toHex());
    return hash;
}

QString O1Requestor::hmacSha1(const QString &data) {
    QString hashed(QCryptographicHash::hash(data.toLatin1(), QCryptographicHash::Sha1).toBase64());
    return hashed;
}

QNetworkReply *O1Requestor::put(const QNetworkRequest &req, const QList<O1RequestParameter> &signingParameters, const QByteArray &data) {
    QNetworkRequest request = setup(req, signingParameters, QNetworkAccessManager::PutOperation);
    return addTimer(manager_->put(request, data));
}

QNetworkReply *O1Requestor::addTimer(QNetworkReply *reply) {
    (void)new TimedReply(reply);
    return reply;
}

QNetworkRequest O1Requestor::setup(const QNetworkRequest &req, const QList<O1RequestParameter> &signingParameters, QNetworkAccessManager::Operation operation) {
    // Collect OAuth parameters
    QList<O1RequestParameter> oauthParams;
    oauthParams.append(O1RequestParameter(O2_OAUTH_CONSUMER_KEY, authenticator_->clientId().toLatin1()));
    oauthParams.append(O1RequestParameter(O2_OAUTH_VERSION, "1.0"));
    oauthParams.append(O1RequestParameter(O2_OAUTH_TOKEN, authenticator_->token().toLatin1()));
    oauthParams.append(O1RequestParameter(O2_OAUTH_SIGNATURE_METHOD, O2_SIGNATURE_TYPE_HMAC_SHA1));
    oauthParams.append(O1RequestParameter(O2_OAUTH_NONCE, O1::nonce()));
    oauthParams.append(O1RequestParameter(O2_OAUTH_TIMESTAMP, QString::number(QDateTime::currentDateTimeUtc().toTime_t()).toLatin1()));

    // Add signature parameter
    QByteArray signature = authenticator_->sign(oauthParams, signingParameters, req.url(), operation, authenticator_->clientSecret(), authenticator_->tokenSecret());
    oauthParams.append(O1RequestParameter(O2_OAUTH_SIGNATURE, signature));

    // Return a copy of the original request with authorization header set
    QNetworkRequest request(req);
    request.setRawHeader(O2_HTTP_AUTHORIZATION_HEADER, O1::buildAuthorizationHeader(oauthParams));
    return request;
}

#include "o1requestor.moc"
