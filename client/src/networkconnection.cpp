#include <QDebug>
#include "networkconnection.h"

NetworkConnection::NetworkConnection(QObject *parent) :
    QObject(parent),
    netManager(new QNetworkAccessManager()),
    netConfManager(new QNetworkConfigurationManager()),
    m_netConnected(false)
{
    QList<QNetworkConfiguration> activeConfigs = netConfManager->allConfigurations();
    QList<QNetworkConfiguration>::const_iterator netIterator;

    for (netIterator = activeConfigs.constBegin(); netIterator != activeConfigs.constEnd(); ++netIterator) {
        if ((*netIterator).state() == QNetworkConfiguration::Active) {
            netSession = new QNetworkSession(*netIterator);
            netSession->open();
            netManager->setConfiguration(*netIterator);
            stateChaged(netSession->state());
        }
    }

    netSession = new QNetworkSession(netConfManager->defaultConfiguration());
    netSession->open();
    connect(netSession, SIGNAL(stateChanged(QNetworkSession::State)),
            this, SLOT(stateChaged(QNetworkSession::State)));
}

NetworkConnection::~NetworkConnection()
{
    delete netManager;
    delete netConfManager;
    delete netSession;
}

void NetworkConnection::stateChaged(QNetworkSession::State state) {
    if (state == QNetworkSession::Connected) {
        setNetConnected(true);
    }
    else {
        setNetConnected(false);
    }
}

bool NetworkConnection::netConnected() const {
    return m_netConnected;
}

void NetworkConnection::setNetConnected(bool val) {
    if (val != m_netConnected) {
        m_netConnected = val;
        emit netConnectedChanged();
    }
}

QNetworkAccessManager* NetworkConnection::getNetworkAccessManager() {
    return netManager;
}


