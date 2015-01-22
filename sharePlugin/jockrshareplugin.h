#ifndef JOCKRTRANSFERIFACE_H
#define JOCKRTRANSFERIFACE_H

#include <TransferEngine-qt5/transferplugininterface.h>
#include <TransferEngine-qt5/transferplugininfo.h>
#include <TransferEngine-qt5/transfermethodinfo.h>
#include <TransferEngine-qt5/mediatransferinterface.h>

class Q_DECL_EXPORT JockrSharePlugin : public QObject, public TransferPluginInterface
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "harbour.jockr.transfer.plugin")
    Q_INTERFACES(TransferPluginInterface)
public:
    JockrSharePlugin();
    ~JockrSharePlugin();

    MediaTransferInterface *transferObject();
    TransferPluginInfo *infoObject();
    QString pluginId() const;
    bool enabled() const;
};

#endif // JOCKRTRANSFERIFACE_H
