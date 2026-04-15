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

void ApiClient::setBearer(QString token) {
    m_bearerToken = token;
}

qint32 ApiClient::auth(const QString &name, const QString &password, AuthType type) {
    QString method;
    switch (type) {
    case AuthType::LOGIN:
        method = "login";
        break;
    case AuthType::REGISTER:
        method = "signup";
        break;
    }
    return apiCall(RequestType::POST, method, {{"name", name}, {"password", password}});
    /*, [this](const QJsonObject &response) {
        m_bearerToken = (QString)response["bearer_token"].toString();
        emit authSuccess();
    }*/
}

qint32 ApiClient::getLanguages() {
    /*apiCall(RequestType::GET, "languages", {}, [this](const QJsonObject &response) {
        emit languagesReceived(response["languages"].toArray());
    });*/
}

qint32 ApiClient::apiCall(RequestType type, QString method, QJsonObject data) {
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
    }
    quint32 requestId = m_request_id++;
    connect(reply, &QNetworkReply::finished, this, [this, reply, requestId]() {
        qint32 status = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
        QJsonParseError err;
        QJsonObject response = QJsonDocument::fromJson(reply->readAll(), &err).object();
        if (err.error != QJsonParseError::NoError) {
            status = 500;
            response = {{"error", "JSON parse error: " + err.errorString()}};
        }
        reply->deleteLater();
        emit apiResult(requestId, status, response);
    });
    return requestId;
}
