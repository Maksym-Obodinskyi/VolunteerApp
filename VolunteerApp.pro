QT += quick network sql

SOURCES += \
        ConfigManager.cpp \
        Request.cpp \
        RequestController.cpp \
        RequestManager.cpp \
        RequestModel.cpp \
        SessionManager.cpp \
        User.cpp \
        main.cpp \
        message.cpp

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
    Request.h \
    RequestController.h \
    RequestManager.h \
    RequestModel.h \
    SessionManager.h \
    User.h \
    message.h \
    responce.h

PKGCONFIG +=    fmt \
                rapidjson

DISTFILES +=
