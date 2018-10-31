#include "imagesoundmodelmanager.h"
#include <QUrl>
#include <QDir>
#include <QDebug>
#include <QFile>
#include <QThread>
#include <QTextStream>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QPixmap>

ImageSoundModelManager::ImageSoundModelManager(QObject *parent)
    : QObject(parent),
      mModel(std::make_unique<ImageSoundsModel>())
{
    initModel();
    connect(&mWebCtrl, &QNetworkAccessManager::finished, this, &ImageSoundModelManager::downloadFinished);
}

ImageSoundsModel *ImageSoundModelManager::getModel() const
{
    return mModel.get();
}
const QString BaseDirPath ="../LetterDrawer/img/gameImg";
const QDir BaseDir = {BaseDirPath};
void ImageSoundModelManager::addImageSoundToModel(const QString &imageName,
                                                  QString imageFilePath,
                                                  const QString& imageSounds)
{
    createDirIfNedded(imageName);

    bool hasImage = mModel->hasImage(imageName);
    ImageSounds& img = hasImage ? mModel->getImage(imageName) : mModel->addImage(imageName);
    img.setImgSounds(imageSounds);

    QUrl url(imageFilePath);
    if(!imageFilePath.contains("http")){
        qDebug() << imageFilePath << " Is local";
    } else {
        dowloadFile(imageName, imageFilePath);
        qDebug() << imageFilePath << " Is not local";
    }
    img.setImgPath(imageFilePath);
    createInfoFile(imageName, imageSounds);
}

void ImageSoundModelManager::downloadFinished(QNetworkReply *repl)
{
    if(repl->isFinished()){
        QPixmap pix;
        pix.loadFromData(repl->readAll());
        pix.save(mCurrentFileDownloaded);
        /*
        QFile f(mCurrentFileDownloaded);
        if(f.open(QIODevice::WriteOnly)){
//            QPixmap pix();
//            QImage img(repl->readAll(),)
            f.write(repl->readAll());
        } else {
            qDebug() << "Failed to write " << mCurrentFileDownloaded;
        }
        */
    }
}

void ImageSoundModelManager::initModel()
{
    for(const auto& dir : BaseDir.entryList(QDir::Dirs | QDir::NoDotAndDotDot)){
        ImageSounds& img = mModel->addImage(dir);
        QFile f(BaseDir.absoluteFilePath(QString("%1/sounds.txt").arg(dir)));
        if(f.open(QIODevice::ReadOnly)){
            QString sounds = QString(f.readAll());
            img.setImgSounds(sounds.split(" "));
        }
        img.setImgPath(QString("%1/%2/%2.png").arg(BaseDirPath).arg(dir));
    }
}
void ImageSoundModelManager::createDirIfNedded(const QString &imageName)
{
    if(BaseDir.exists(imageName)){

    } else {
        if(BaseDir.mkdir(imageName)){
            while(!BaseDir.exists(imageName)){
                qDebug() << ".";
                QThread::msleep(100);
            }
        } else {
            qDebug() << " Failed to create dir " << BaseDir.absoluteFilePath(imageName);
        }
    }
}

void ImageSoundModelManager::createInfoFile(const QString &imageName, const QString &sounds)
{
    if(BaseDir.exists(imageName)){
        QDir dir(BaseDir.absoluteFilePath(imageName));
        QFile f(dir.absoluteFilePath("sounds.txt"));
        if(f.open(QIODevice::WriteOnly)){
            QTextStream str(&f);
            str.setCodec("UTF-8");
            str << sounds;
            f.close();
        } else {
            qDebug() << "Failed to write in " << dir.absoluteFilePath("sounds.txt");
        }
    } else {
        qDebug() << " Could not find dir " << BaseDir.filePath(imageName);
    }
}

void ImageSoundModelManager::dowloadFile(const QString &imageName, QString &imageFilePath)
{
    mWebCtrl.get(QNetworkRequest(QUrl(imageFilePath)));
    QDir dir(BaseDir.absoluteFilePath(imageName));
    mCurrentFileDownloaded = dir.absoluteFilePath(QString("%1.png").arg(imageName));
    imageFilePath = (QString("../LetterDrawer/img/gameImg/%1.png").arg(imageName));
}
