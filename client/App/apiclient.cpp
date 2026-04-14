#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonObject>
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
        QString token = response["bearer_token"].toString();
        m_bearerToken = token;
        emit authSuccess();
    });
}

void ApiClient::getLanguages() {
    apiCall(RequestType::GET, "languages", {}, [this](const QJsonObject &response) {
        emit languagesReceived(response["languages"].toArray());
    });
}

void ApiClient::apiCall(RequestType type, QString method, QJsonObject data, std::function<void(const QJsonObject &response)> postProcess) {
    QUrl url(m_host + "/" + method + ".php");
    QNetworkReply *reply = nullptr;
    switch (type) {
    case RequestType::GET: {
        QUrlQuery query;
        for (auto it = data.begin(); it != data.end(); ++it) {
            query.addQueryItem(it.key(), it.value().toString());
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
    default:
        emit apiError("Unknown request type");
        return;
    }
    connect(reply, &QNetworkReply::finished, this,
            [this, reply, postProcess]()
            {
                int status = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
                QJsonObject response = QJsonDocument::fromJson(reply->readAll()).object();
                reply->deleteLater();
                if (status >= 200 && status < 300) {
                    postProcess(response);
                } else {
                    emit apiError(response["error"].toString());
                }
            });
}
