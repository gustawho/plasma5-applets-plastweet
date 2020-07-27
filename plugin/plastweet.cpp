#include "plastweet.h"
#include "backend.h"

#include <QtQml>
#include <QDebug>

void Plastweet::registerTypes(const char *uri) {
    Q_ASSERT(uri == QLatin1String("org.kde.plastweet"));

    qmlRegisterType<BackEnd>(uri, 1, 0, "BackEnd");
}
