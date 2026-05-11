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
    Q_PROPERTY(QString userRole READ userRole NOTIFY userChanged)
    Q_PROPERTY(bool authenticated READ authenticated NOTIFY userChanged)
public:
    explicit ApiClient(QString host, QObject *parent = nullptr);
    Q_INVOKABLE void auth(const QString &name, const QString &password, AuthType type, const QString &role = "student", const QString &recovery = "");
    Q_INVOKABLE void recoverPassword(const QString &name, const QString &recovery, const QString &newPassword);
    Q_INVOKABLE void logout();
    Q_INVOKABLE void getLanguages();
    Q_INVOKABLE void getThemes(qint32 lang_id);
    Q_INVOKABLE void getTasks(qint32 theme_id);
    Q_INVOKABLE void getTheory(qint32 theme_id);
    Q_INVOKABLE void getTask(qint32 task_id);
    Q_INVOKABLE void getProgress();
    Q_INVOKABLE void runSolution(qint32 task_id, QString codeText, QString inputText);
    Q_INVOKABLE void checkSolution(qint32 task_id, QString codeText);
    Q_INVOKABLE void createLanguage(const QString &name, const QString &shortDescription, const QString &photoUrl);
    Q_INVOKABLE void createTheme(qint32 langId, const QString &topic, const QString &theory);
    Q_INVOKABLE void createTask(qint32 themeId, const QString &task, const QString &publicInput, const QString &publicOutput);
    Q_INVOKABLE void createTest(qint32 taskId, const QString &input, const QString &output);

    QString userRole() const;
    bool authenticated() const;

signals:
    void apiError(const QString error);
    void authSuccess();
    void passwordRecovered();
    void userChanged();
    void languagesReceived(const QJsonArray languages);
    void themesReceived(const QJsonArray themes);
    void tasksReceived(const QJsonArray tasks);
    void theoryReceived(const QJsonObject info);
    void taskReceived(const QString task, const QString publicInput, const QString publicOutput);
    void progressReceived(const QJsonObject progress);
    void solutionRan(const QString result, const QString output);
    void solutionChecked(const QString result);
    void languageCreated(qint32 languageId);
    void themeCreated(qint32 themeId);
    void taskCreated(qint32 taskId);
    void testCreated(qint32 testId);

private:
    void apiCall(RequestType type, QString method, QJsonObject data, std::function<void(const QJsonObject &response)> postProcess);
    const QString m_host;
    QNetworkAccessManager *m_network;
    QString m_bearerToken;
    QString m_userRole;
};

#endif // APICLIENT_H
