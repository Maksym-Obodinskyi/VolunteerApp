QT += quick network

SOURCES += \
        ConfigManager.cpp \
        Request.cpp \
        RequestController.cpp \
        RequestManager.cpp \
        RequestModel.cpp \
        SessionManager.cpp \
        User.cpp \
        main.cpp

RESOURCES += qml.qrc

TRANSLATIONS += \
    VolunteerApp_en_US.ts

CONFIG +=   lrelease \
            embed_translations

QMAKE_CXXFLAGS += -std=c++20

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
    User.h

PKGCONFIG +=    fmt \
                rapidjson
