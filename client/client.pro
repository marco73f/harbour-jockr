include(oauth_lib/oauth.pri)
CONFIG += c++11
QT +=   webkit

TARGET = harbour-jockr

CONFIG += sailfishapp

HEADERS += \
    src/networkconnection.h \
    src/flickrsignin.h \
    src/flickrmodelinterface.h \
    src/flickrfactoryinterface.h

SOURCES += src/harbour-jockr.cpp \
    src/networkconnection.cpp \
    src/flickrsignin.cpp \
    src/flickrmodelinterface.cpp \
    src/flickrfactoryinterface.cpp

OTHER_FILES += qml/harbour-jockr.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    qml/pages/SecondPage.qml \
    rpm/harbour-jockr.changes.in \
    rpm/harbour-jockr.spec \
    rpm/harbour-jockr.yaml \
    translations/*.ts \
    harbour-jockr.desktop \
    qml/pages/ActivityUserPhotos.qml \
    qml/pages/AuthorizationPage.qml \
    qml/pages/ContactsGetList.qml \
    qml/pages/DefaultView.qml \
    qml/pages/ErrorPage.qml \
    qml/pages/FavoritesGetList.qml \
    qml/pages/FirstPage.qml \
    qml/pages/Login.qml \
    qml/pages/PhotoListView.qml \
    qml/pages/PhotosCommentsAdd.qml \
    qml/pages/PhotosCommentsGetList.qml \
    qml/pages/PhotosGetContactsPublicPhotos.qml \
    qml/pages/PhotosGetInfo.qml \
    qml/pages/SecondPage.qml \
    qml/pages/models/ActivityUserPhotosModel.qml \
    qml/pages/models/ContactsGetListModel.qml \
    qml/pages/models/FavoritesGetListModel.qml \
    qml/pages/models/PeopleGetPublicPhotosModel.qml \
    qml/pages/models/PhotoGetRecentModel.qml \
    qml/pages/models/PhotosCommentsGetListModel.qml \
    qml/pages/models/PhotosGetContactsPhotosModel.qml \
    qml/pages/models/PhotosGetContactsPublicPhotosModel.qml \
    qml/pages/models/PhotosGetInfoModel.qml \
    qml/pages/delegates/DefaultGridDelegate.qml \
    qml/pages/delegates/DefaultListDelegate.qml \
    qml/pages/delegates/FlickrImage.qml \
    qml/pages/delegates/FlickrText.qml \
    qml/pages/delegates/Loading.qml \
    qml/pages/delegates/PhotosGetInfoDelegate.qml \
    qml/pages/delegates/TimelineDelegate.qml \
    qml/pages/delegates/UserInfoDelegate.qml \
    qml/pages/FlickrGridView.qml \
    qml/pages/FlickrSlideView.qml \
    qml/pages/models/Peoplepeople.getPublicPhotosModel.qml \
    qml/pages/delegates/JockrBuddyIcon.qml \
    qml/pages/models/PeopleGetPhotosModel.qml \
    qml/pages/PeopleGetPhotosGridPage.qml \
    qml/pages/delegates/JockrImage.qml \
    qml/pages/delegates/JockrPhoto.qml \
    qml/pages/JockrSlideView.qml \
    qml/pages/PhotosGetContactsPhotosPage.qml \
    qml/pages/PeopleGetPhotosPage.qml \
    qml/pages/PeopleGetPublicPhotosPage.qml \
    qml/pages/UserPage.qml \
    qml/pages/PhotosetsGetListGridPage.qml \
    qml/pages/models/PhotosetsGetListModel.qml \
    qml/pages/models/PhotosetsGetPhotosModel.qml \
    qml/pages/PhotosetsGetPhotosGridPage.qml \
    qml/pages/delegates/JockrPhotoset.qml \
    qml/pages/models/PhotosetsGetInfo.qml \
    qml/pages/GroupsGetListGridPage.qml \
    qml/pages/models/GroupsGetListModel.qml \
    qml/pages/About.qml \
    qml/pages/Settings.qml \
    qml/pages/JockrMainView.qml \
    qml/pages/delegates/JockrBuddyPhoto.qml \
    qml/pages/ContactsGetPhotosGridPage.qml \
    qml/pages/GroupsGetPhotosGridPage.qml \
    qml/pages/models/GroupGetPhotosModel.qml \
    qml/pages/models/FavoritesAddModel.qml \
    qml/pages/models/FavoritesRemoveModel.qml \
    qml/pages/sharePluginUI.qml \
    qml/pages/SignOutPage.qml \
    qml/pages/PhotoViewer.qml \
    qml/pages/models/PhotosetsCreateModel.qml \
    qml/pages/models/PhotosetsDeleteModel.qml \
    qml/pages/models/PhotosetsRemovePhotosModel.qml \
    qml/pages/models/PhotosetsAddPhotoModel.qml \
    qml/pages/PhotosetsAddPage.qml \
    qml/pages/PhotosetsRemovePage.qml \
    qml/favoritesFunctions.js \
    qml/arrFunction.js

# to disable building translations every time, comment out the
# following CONFIG line
#CONFIG += sailfishapp_i18n
#TRANSLATIONS += translations/harbour-jockr-de.ts

RESOURCES += \
    jockr.qrc

