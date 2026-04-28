#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QUrlQuery>
#include "apiclient.h"

enum class RequestType {
    GET = 0,
    POST = 1
};

enum class AuthType {
    LOGIN = 0,
    REGISTER = 1
};

ApiClient::ApiClient(QString host, QObject *parent)
    : m_host{host}, QObject{parent} {
    m_network = new QNetworkAccessManager(this);
}

void ApiClient::auth(const QString &name, const QString &password, AuthType type, const QString &role) {
    QString method;
    switch (type) {
    case AuthType::LOGIN:
        method = "login";
        break;
    case AuthType::REGISTER:
        method = "signup";
        break;
    default:
        emit apiError("Unknown auth type");
        return;
    }
    apiCall(RequestType::POST, method, {{"name", name}, {"password", password}, {"role", role}}, [this](const QJsonObject &response) {
        m_bearerToken = response["bearer_token"].toString();
        m_userRole = response["role"].toString();
        m_userId = response["user_id"].toInt();
        emit userChanged();
        emit authSuccess();
    });
}

void ApiClient::getLanguages() {
    apiCall(RequestType::GET, "languages", {}, [this](const QJsonObject &response) {
        emit languagesReceived(response["languages"].toArray());
    });
}

void ApiClient::getThemes(qint32 lang_id) {
    apiCall(RequestType::GET, "themes", {{"lang_id", lang_id}}, [this](const QJsonObject &response) {
        emit themesReceived(response["themes"].toArray());
    });
}

void ApiClient::getTheory(qint32 theme_id) {
    apiCall(RequestType::GET, "theory", {{"theme_id", theme_id}}, [this](const QJsonObject &response) {
        emit theoryReceived(response);
    });
}

void ApiClient::getTask(qint32 task_id) {
    apiCall(RequestType::GET, "task", {{"task_id", task_id}}, [this](const QJsonObject &response) {
        emit taskReceived(response["task"].toString(), response["public_input"].toString(), response["public_output"].toString());
    });
}

void ApiClient::runSolution(QString codeText, QString inputText) {
    apiCall(RequestType::POST, "run_task", {{"text", codeText}, {"input", inputText}}, [this](const QJsonObject &response) {
        emit solutionRan(response["result"].toString(), response["output"].toString());
    });
}

void ApiClient::checkSolution(qint32 task_id, QString codeText) {
    apiCall(RequestType::POST, "check_task", {{"task_id", task_id}, {"text", codeText}}, [this](const QJsonObject &response) {
        emit solutionChecked(response["result"].toString());
    });
}

void ApiClient::createTheme(qint32 langId, const QString &topic, const QString &theory) {
    apiCall(RequestType::POST, "create_theme", {{"lang_id", langId}, {"topic", topic}, {"theory", theory}}, [this](const QJsonObject &response) {
        emit themeCreated(response["theme_id"].toInt());
    });
}

void ApiClient::createTask(qint32 themeId, const QString &task, const QString &publicInput, const QString &publicOutput) {
    apiCall(RequestType::POST, "create_task", {{"theme_id", themeId}, {"task", task}, {"public_input", publicInput}, {"public_output", publicOutput}}, [this](const QJsonObject &response) {
        emit taskCreated(response["task_id"].toInt());
    });
}

QString ApiClient::userRole() const {
    return m_userRole;
}

qint32 ApiClient::userId() const {
    return m_userId;
}

void ApiClient::apiCall(RequestType type, QString method, QJsonObject data, std::function<void(const QJsonObject &response)> postProcess) {
    QUrl url(m_host + "/" + method + ".php");
    QNetworkReply *reply = nullptr;
    switch (type) {
    case RequestType::GET: {
        QUrlQuery query;
        for (auto it = data.begin(); it != data.end(); ++it) {
            query.addQueryItem(it.key(), it.value().toVariant().toString());
        }
        url.setQuery(query);
        QNetworkRequest request(url);
        if (!m_bearerToken.isEmpty()) {
            request.setRawHeader("Authorization", "Bearer " + m_bearerToken.toUtf8());
        }
        reply = m_network->get(request);
        break;
    }
    case RequestType::POST: {
        QNetworkRequest request(url);
        request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
        if (!m_bearerToken.isEmpty()) {
            request.setRawHeader("Authorization", "Bearer " + m_bearerToken.toUtf8());
        }
        QByteArray body = QJsonDocument(data).toJson(QJsonDocument::Compact);
        reply = m_network->post(request, body);
        break;
    }
    }
    connect(reply, &QNetworkReply::finished, this, [this, reply, postProcess]() {
        qint32 status = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
        QJsonParseError err;
        QJsonObject response = QJsonDocument::fromJson(reply->readAll(), &err).object();
        reply->deleteLater();
        if (err.error != QJsonParseError::NoError) {
            emit apiError("JSON parse error: " + err.errorString());
        } else if (status < 200 || status >= 300) {
            emit apiError(response["error"].toString());
        } else {
            postProcess(response);
        }
    });
}
