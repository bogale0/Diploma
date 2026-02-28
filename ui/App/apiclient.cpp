#include "apiclient.h"
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonObject>
#include <QJsonDocument>
#include <QUrl>

ApiClient::ApiClient(QString host, QObject *parent)
    : m_host{host}, QObject{parent} {
    m_network = new QNetworkAccessManager(this);
}

void ApiClient::auth(const QString &name, const QString &password, const QString &type) {
    apiCall(type, {
                      {"name", name},
                      {"password", password}
                  }, [this](QJsonObject &response) {
                QString token = response["bearer_token"].toString();
                m_bearerToken = token;
                emit authSuccess();
            });
}

void ApiClient::apiCall(QString method, QJsonObject data, const std::function<void(QJsonObject &response)> &postProcess) {
    const QUrl endpoint(m_host + "/" + method + ".php");
    QNetworkRequest request(endpoint);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QByteArray body = QJsonDocument(data).toJson(QJsonDocument::Compact);
    QNetworkReply *reply = m_network->post(request, body); //add other methods later
    connect(reply, &QNetworkReply::finished, this,
            [this, reply, postProcess]()
            {
                reply->deleteLater();
                int status = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
                QJsonObject response = QJsonDocument::fromJson(reply->readAll()).object();
                if (status >= 200 && status < 300) {
                    postProcess(response);
                } else {
                    emit networkError(response["error"].toString());
                }
            }
            );
}
