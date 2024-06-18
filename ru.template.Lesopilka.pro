TARGET = ru.template.Lesopilka

CONFIG += \
    auroraapp

PKGCONFIG += \

SOURCES += \
    src/dbmanager.cpp \
    src/main.cpp \

HEADERS += \
    src/dbmanager.h

DISTFILES += \
    qml/pages/BreedInputDialog.qml \
    qml/pages/DiameterInputDialog.qml \
    qml/pages/Field.qml \
    qml/pages/HeightInputDialog.qml \
    qml/pages/Location.qml \
    qml/pages/Menu.qml \
    rpm/ru.template.Lesopilka.spec \

AURORAAPP_ICONS = 86x86 108x108 128x128 172x172

CONFIG += auroraapp_i18n

TRANSLATIONS += \
    translations/ru.template.Lesopilka.ts \
    translations/ru.template.Lesopilka-ru.ts \

RESOURCES += \
    resources.qrc
