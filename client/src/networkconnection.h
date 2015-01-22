#ifndef NETWORKCONNECTION_H
#define NETWORKCONNECTION_H

#include <QObject>
#include <QNetworkSession>
#include <QNetworkAccessManager>
#include <QNetworkConfigurationManager>

class NetworkConnection : public QObject
{
    Q_OBJECT
    Q_PROPERTY (bool netConnected READ netConnected WRITE setNetConnected NOTIFY netConnectedChanged)

public:
    explicit NetworkConnection(QObject *parent = 0);
    ~NetworkConnection();

    bool netConnected() const;
    QNetworkAccessManager* getNetworkAccessManager();
    void setNetConnected(bool val);

signals:
    void netConnectedChanged();

public slots:
    void stateChaged(QNetworkSession::State state);

private:
    bool m_netConnected;
    QNetworkAccessManager *netManager;
    QNetworkConfigurationManager *netConfManager;
    QNetworkSession *netSession;
};

#endif // NETWORKCONNECTION_H
