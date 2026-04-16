#ifndef APICLIENT_H
#define APICLIENT_H

#include <QObject>
#include <QJsonArray>
#include <QJsonObject>
class QNetworkAccessManager;
enum class RequestType;
enum class AuthType;

class ApiClient : public QObject {
    Q_OBJECT
public:
    explicit ApiClient(QString host, QObject *parent = nullptr);
    Q_INVOKABLE void auth(const QString &name, const QString &password, AuthType type);
    Q_INVOKABLE void getLanguages();
    Q_INVOKABLE void getThemes(qint32 lang_id);
    Q_INVOKABLE void getTheory(qint32 theme_id);
    Q_INVOKABLE void getTask(qint32 task_id);
    Q_INVOKABLE void checkSolution(qint32 theme_id, QString codeText);

signals:
    void apiError(const QString error);
    void authSuccess();
    void languagesReceived(const QJsonArray languages);
    void themesReceived(const QJsonArray themes);
    void theoryReceived(const QJsonObject info);
    void taskReceived(const QString task);
    void solutionChecked(const QString result);

private:
    void apiCall(RequestType type, QString method, QJsonObject data, std::function<void(const QJsonObject &response)> postProcess);
    const QString m_host;
    QNetworkAccessManager *m_network;
    QString m_bearerToken;
};

#endif // APICLIENT_H
