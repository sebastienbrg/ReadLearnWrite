#ifndef IMAGESOUNDMODELMANAGER_H
#define IMAGESOUNDMODELMANAGER_H

#include <QObject>
#include <memory>
#include <QNetworkAccessManager>
#include "lettermodels_global.h"
#include "imagesoundsmodel.h"
class QNetworkReply;

class LETTERMODELSSHARED_EXPORT ImageSoundModelManager : public QObject
{
    Q_OBJECT
public:
    explicit ImageSoundModelManager(QObject *parent = nullptr);
    ImageSoundsModel* getModel() const;
    Q_INVOKABLE void addImageSoundToModel(const QString& imageName, QString imageFilePath, const QString &imageSounds);
private slots:
    void downloadFinished(QNetworkReply* repl);
private:
    void initModel();
    void createDirIfNedded(const QString& imageName);
    void createInfoFile(const QString& imageName, const QString& sounds);
    std::unique_ptr<ImageSoundsModel> mModel;
    void dowloadFile(const QString& imageName, QString &imageFilePath);


    QNetworkAccessManager mWebCtrl;
    QByteArray mDownloadedData;
    QString mCurrentFileDownloaded;

};

#endif // IMAGESOUNDMODELMANAGER_H
