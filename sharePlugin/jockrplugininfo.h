
#ifndef JOCKRPLUGININFO_H
#define JOCKRPLUGININFO_H

#include <TransferEngine-qt5/transferplugininfo.h>
#include <TransferEngine-qt5/transfermethodinfo.h>

class JockrPluginInfo : public TransferPluginInfo
{
    Q_OBJECT
public:
    JockrPluginInfo();
    ~JockrPluginInfo();

    QList<TransferMethodInfo> info() const;
    void query();
    bool ready() const;

private:
    QList<TransferMethodInfo> m_infoList;
    bool m_ready;

};

#endif // JOCKRPLUGININFO_H
