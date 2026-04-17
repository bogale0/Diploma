#include <QNetworkAccessManager>
#include <QNetworkReply>
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

void ApiClient::auth(const QString &name, const QString &password, AuthType type) {
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
    apiCall(RequestType::POST, method, {{"name", name}, {"password", password}}, [this](const QJsonObject &response) {
        m_bearerToken = response["bearer_token"].toString();
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
        emit taskReceived(response["task"].toString());
    });
}

void ApiClient::checkSolution(qint32 task_id, QString codeText) {
    apiCall(RequestType::POST, "check_task", {{"task_id", task_id}, {"text", codeText}}, [this](const QJsonObject &response) {
        emit solutionChecked(response["result"].toString());
    });
}

/*void ApiClient::themeInfo(qint32 theme_id, ThemeInfoType type) {
    auto it = m_cacheThemeInfo.find(theme_id);
    if (it != m_cacheThemeInfo.end()) {
        switch (type) {
        case ThemeInfoType::THEORY:
            emit theoryReceived(it.value()["theory"].toString());
            break;
        case ThemeInfoType::TASK:
            emit taskReceived(it.value()["task"].toString());
            break;
        }
        return;
    }
    apiCall(RequestType::GET, "theme_info", {{"theme_id", theme_id}}, [this, theme_id, type](const QJsonObject &response) {
        m_cacheThemeInfo.insert(theme_id, response);
        switch (type) {
        case ThemeInfoType::THEORY:
            emit theoryReceived(response["theory"].toString());
            break;
        case ThemeInfoType::TASK:
            emit taskReceived(response["task"].toString());
            break;
        }
    });
}*/

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
        reply = m_network->get(request);
        break;
    }
    case RequestType::POST: {
        QNetworkRequest request(url);
        request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
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
