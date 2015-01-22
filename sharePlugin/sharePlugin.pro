TEMPLATE = lib

TARGET = $$qtLibraryTarget(jockrshareplugin)
CONFIG += plugin
DEPENDPATH += .

CONFIG += link_pkgconfig
PKGCONFIG += nemotransferengine-qt5

CONFIG += c++11
QT +=   webkit

include(oauth.pri)
include(client.pri)

HEADERS += \
    jockrplugininfo.h \
    jockrmediatransfer.h \
    jockrshareplugin.h \
    flickruploadinterface.h

SOURCES += \
    jockrplugininfo.cpp \
    jockrmediatransfer.cpp \
    jockrshareplugin.cpp \
    flickruploadinterface.cpp

target.path = /usr/lib/nemo-transferengine/plugins
INSTALLS += target

