#include "jockrshareplugin.h"
#include "jockrplugininfo.h"
#include "jockrmediatransfer.h"

#include <QtPlugin>

JockrSharePlugin::JockrSharePlugin()
{

}

JockrSharePlugin::~JockrSharePlugin()
{

}

QString JockrSharePlugin::pluginId() const
{
    return QLatin1String("JockrSharePlugin");
}

bool JockrSharePlugin::enabled() const
{
    return true;
}

TransferPluginInfo *JockrSharePlugin::infoObject()
{
    return new JockrPluginInfo;
}

MediaTransferInterface *JockrSharePlugin::transferObject()
{
    return new JockrMediaTransfer;
}
