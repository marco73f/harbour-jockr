#include "jockrplugininfo.h"
#include <QDebug>

JockrPluginInfo::JockrPluginInfo(): m_ready(false)
{
}

JockrPluginInfo::~JockrPluginInfo()
{

}

QList<TransferMethodInfo> JockrPluginInfo::info() const
{
    return m_infoList;
}

void JockrPluginInfo::query()
{
    TransferMethodInfo info;

    QStringList capabilities;
    capabilities << QLatin1String("image/*")
                 << QLatin1String("video/*");

    info.displayName     = QLatin1String("Jockr");
    info.methodId        = QLatin1String("JockrSharePlugin");
    info.shareUIPath     = QLatin1String("/usr/share/harbour-jockr/qml/pages/sharePluginUI.qml");
    info.capabilitities  = capabilities;
    m_infoList << info;
    m_ready = true;
    emit infoReady();
}

bool JockrPluginInfo::ready() const
{
    return m_ready;
}
