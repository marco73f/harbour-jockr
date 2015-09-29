#include "jockrsettings.h"
#include <QDebug>

const char STORE_ORGANIZATION[] = "marco73f";
const char STORE_APPLICATION[] = "harbour-jockr";

JockrSettings::JockrSettings(QObject *parent) :
    QObject(parent)
{
    qSettings = new QSettings(STORE_ORGANIZATION, STORE_APPLICATION, parent);
    crypto = new SimpleCrypt(Q_UINT64_C(0x0c1ad3a5acb8f021));
}

JockrSettings::~JockrSettings() {
    delete crypto;
    crypto = 0;
}

void JockrSettings::load() {
    _xmlAlbumList = crypto->decryptToString(qSettings->value("xmlAlbumList").toString());
}

void JockrSettings::remove() {
    qSettings->remove("xmlAlbumList");
    _xmlAlbumList.clear();
}

QString JockrSettings::xmlAlbumList() {
    return _xmlAlbumList;
}

void JockrSettings::setXmlAlbumList(const QString &xmlAlbumList) {
    _xmlAlbumList = xmlAlbumList;
    qSettings->setValue("xmlAlbumList", crypto->encryptToString(_xmlAlbumList));
}

