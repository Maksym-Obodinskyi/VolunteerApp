QT += quick network sql

SOURCES += \
        ConfigManager.cpp \
        RequestController.cpp \
        RequestInfo.cpp \
        RequestManager.cpp \
        RequestModel.cpp \
        SessionManager.cpp \
        UserInfo.cpp \
        main.cpp \
        message.cpp \
        responce.cpp

RESOURCES += qml.qrc

TRANSLATIONS += \
    VolunteerApp_en_US.ts

CONFIG +=   lrelease \
            embed_translations

QMAKE_CXXFLAGS += -std=c++2a

qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    ConfigManager.h \
    Logger.h \
    RequestController.h \
    RequestInfo.h \
    RequestManager.h \
    RequestModel.h \
    SessionManager.h \
    UserInfo.h \
    message.h \
    responce.h

PKGCONFIG +=    fmt \
                rapidjson

DISTFILES +=
