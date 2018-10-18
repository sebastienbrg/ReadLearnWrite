#include "imagesoundsmodel.h"
#include <QModelIndex>
#include <QByteArray>

namespace  {
    QHash<int, QByteArray> roles = {
        { ImageSoundsModel::NameRole, "name"},
        { ImageSoundsModel::FilePathRole, "filePath"},
        { ImageSoundsModel::SoundsRole, "sounds"}
    };
}

ImageSoundsModel::ImageSoundsModel() : QAbstractListModel()
{
}

ImageSoundsModel::~ImageSoundsModel()
{

}

ImageSounds& ImageSoundsModel::addImage(const QString &name)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    mImageList << ImageSounds(name);
    endInsertRows();
    return mImageList.last();
}

int ImageSoundsModel::rowCount(const QModelIndex &) const
{
    return mImageList.length();
}

QVariant ImageSoundsModel::data(const QModelIndex &index, int role) const
{
    if(index.row() >= 0 && index.row() < mImageList.length()){
        const ImageSounds& img = mImageList.at(index.row());
        switch (role) {
        case NameRole:
            return img.name();
        case FilePathRole:
            return img.imgPath();
        case SoundsRole:
            return img.imgSounds();
        default:
            break;
        }

    }
    return QVariant();
}

QHash<int, QByteArray> ImageSoundsModel::roleNames() const
{
    return roles;
}

ImageSounds::ImageSounds(const QString &name): mName(name)
{

}

QString ImageSounds::name() const
{
    return mName;
}

QString ImageSounds::imgPath() const
{
    return mImgPath;
}

void ImageSounds::setImgPath(const QString &imgPath)
{
    mImgPath = imgPath;
}

QStringList ImageSounds::imgSounds() const
{
    return mImgSounds;
}

void ImageSounds::setImgSounds(const QStringList &imgSounds)
{
    mImgSounds = imgSounds;
}
