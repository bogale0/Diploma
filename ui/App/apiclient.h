#ifndef APICLIENT_H
#define APICLIENT_H

#include <QObject>
class QNetworkAccessManager;

class ApiClient : public QObject
{
    Q_OBJECT
public:
    explicit ApiClient(QString host, QObject *parent = nullptr);
    Q_INVOKABLE void auth(const QString &name, const QString &password, const QString &type);

signals:
    void networkError(const QString &error);
    void authSuccess();

private:
    void apiCall(QString method, QJsonObject data, const std::function<void(QJsonObject &response)> &postProcess);
    const QString m_host;
    QNetworkAccessManager *m_network;
    QString m_bearerToken;
};

#endif // APICLIENT_H
