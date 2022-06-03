QT += quick network

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
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
CONFIG += lrelease
CONFIG += embed_translations

QMAKE_CXXFLAGS += -std=c++20

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES +=

HEADERS += \
    Logger.h \
    Request.h \
    RequestController.h \
    RequestManager.h \
    RequestModel.h \
    SessionManager.h \
    User.h

PKGCONFIG += fmt
