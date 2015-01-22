/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#include <QtQuick>
#include <QDebug>

#include <sailfishapp.h>
#include "networkconnection.h"
#include "flickrsignin.h"
#include "o1flickr.h"
#include "flickrfactoryinterface.h"

static O1Flickr *o1Flickr;
static FlickrSignIn *flickrSignIn;
static NetworkConnection *networkConnection;
static FlickrFactoryInterface *flickrFactoryInterface;

static QJSValue qjsvalue_globalvalue_provider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)

    static int marginValue = 5;
    static int per_pageValue = 100; //defaults to 100. The maximum allowed value is 500.
    static int pageValue = 1;  //default 1
    QJSValue globalValue = scriptEngine->newObject();
    globalValue.setProperty("margin", marginValue);
    globalValue.setProperty("per_page", per_pageValue);
    globalValue.setProperty("page", pageValue);
    return globalValue;
}


static QObject *qobject_networkConnection_provider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    return networkConnection;
}

static QObject *qobject_flickrSignIn_provider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    return flickrSignIn;
}

static QObject *qobject_flickrFactoryInterface_provider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    return flickrFactoryInterface;
}

int main(int argc, char *argv[])
{
    networkConnection = new NetworkConnection();
    o1Flickr = new O1Flickr();
    //o1Flickr->setNetworkAccessManager(networkConnection->getNetworkAccessManager());
    flickrSignIn = new FlickrSignIn(o1Flickr);
    flickrFactoryInterface = new FlickrFactoryInterface(o1Flickr, networkConnection->getNetworkAccessManager());

    qmlRegisterSingletonType("Jockr", 1, 0, "GValue", qjsvalue_globalvalue_provider);
    qmlRegisterSingletonType<NetworkConnection>("Jockr", 1, 0, "ConnMan", qobject_networkConnection_provider);
    qmlRegisterSingletonType<FlickrSignIn>("Jockr", 1, 0, "OAuth", qobject_flickrSignIn_provider);
    qmlRegisterSingletonType<FlickrFactoryInterface>("Jockr", 1, 0, "FactoryModelInterface", qobject_flickrFactoryInterface_provider);

    QGuiApplication* app = SailfishApp::application(argc, argv);
    QScopedPointer<QQuickView> view(SailfishApp::createView());

    QTranslator translator;
    if (translator.load(QLocale(), "harbour-jockr", "-", "/usr/share/harbour-jockr/translations")) {
        qDebug() << (qApp->installTranslator(&translator) ? "Translator installed" : "Error installing translator");
    }
    else {
        qDebug() << "Cannot load translation file";
    }

    view->setSource(SailfishApp::pathTo("qml/harbour-jockr.qml"));
    view->show();

    return app->exec();
}
