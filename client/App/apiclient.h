#ifndef APICLIENT_H
#define APICLIENT_H

#include <QObject>
#include <QJsonObject>
using Qt::staticMetaObject;
class QNetworkAccessManager;
enum class RequestType;
enum class AuthType;

class ApiClient : public QObject {
    Q_OBJECT
public:
    explicit ApiClient(QString host, QObject *parent = nullptr);
    Q_INVOKABLE void setBearer(QString token);
    Q_INVOKABLE qint32 auth(const QString &name, const QString &password, AuthType type);
    Q_INVOKABLE qint32 getLanguages();

signals:
    void apiResult(const qint32 id, const qint32 status, QJsonObject data);

private:
    qint32 apiCall(RequestType type, QString method, QJsonObject data);
    qint32 m_request_id;
    const QString m_host;
    QNetworkAccessManager *m_network;
    QString m_bearerToken;
};

#endif // APICLIENT_H
