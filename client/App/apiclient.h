#ifndef APICLIENT_H
#define APICLIENT_H

#include <QObject>
#include <QJsonArray>
using Qt::staticMetaObject;
class QNetworkAccessManager;
enum class RequestType;
enum class AuthType;

class ApiClient : public QObject {
    Q_OBJECT
public:
    explicit ApiClient(QString host, QObject *parent = nullptr);
    Q_INVOKABLE void auth(const QString &name, const QString &password, AuthType type);
    Q_INVOKABLE void getLanguages();

signals:
    void apiError(const QString &error);
    void authSuccess();
    void languagesReceived(QJsonArray languages);

private:
    void apiCall(RequestType type, QString method, QJsonObject data, std::function<void(const QJsonObject &response)> postProcess);
    const QString m_host;
    QNetworkAccessManager *m_network;
    QString m_bearerToken;
};

#endif // APICLIENT_H
