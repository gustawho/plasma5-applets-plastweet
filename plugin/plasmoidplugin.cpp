#include "plasmoidplugin.h"
#include "backend.h"

#include <QtQml>
#include <QDebug>

void PlasmoidPlugin::registerTypes(const char *uri) {
    Q_ASSERT(uri == QLatin1String("com.gustawho.plastweet"));
    
    qmlRegisterType<BackEnd>(uri, 1, 0, "BackEnd");
}
