// Copyright (C) 2024 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QIcon>
#include "autogen/environment.h"
#include "apiclient.h"

int main(int argc, char *argv[]) {
    set_qt_environment();
    QApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/qt/qml/DiplomaContent/images/icon.png"));
    qmlRegisterSingletonInstance("Backend", 1, 0, "Api", new ApiClient("http://localhost/api/Diploma")); //https://app.bogaledev.ru/api
    QQmlApplicationEngine engine;
    const QUrl url(mainQmlFile);
    QObject::connect(
                &engine, &QQmlApplicationEngine::objectCreated, &app,
                [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.addImportPath(QCoreApplication::applicationDirPath() + "/qml");
    engine.addImportPath(":/");
    engine.load(url);

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
