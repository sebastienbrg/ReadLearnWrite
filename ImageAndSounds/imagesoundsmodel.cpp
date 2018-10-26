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
    qDeleteAll(mImageList);
    mImageList.clear();
}

ImageSounds& ImageSoundsModel::addImage(const QString &name)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    mImageList << new ImageSounds(name);
    connect(mImageList.last(), &ImageSounds::dataChanged, this, &ImageSoundsModel::imageHasChanged);
    endInsertRows();
    return *mImageList.last();
}
static ImageSounds ImgNotFound("404");
ImageSounds &ImageSoundsModel::getImage(const QString &name)
{
    for(auto& img : mImageList){
        if(img->name() == name)
            return *img;
    }
    return ImgNotFound;
}

bool ImageSoundsModel::hasImage(const QString &name) const
{
    return std::any_of(mImageList.begin(), mImageList.end(), [&name](auto img){
        return img->name() == name;
    });
}


int ImageSoundsModel::rowCount(const QModelIndex &) const
{
    return mImageList.length();
}

QVariant ImageSoundsModel::data(const QModelIndex &index, int role) const
{
    if(index.row() >= 0 && index.row() < mImageList.length()){
        const ImageSounds& img = *mImageList.at(index.row());
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

void ImageSoundsModel::imageHasChanged(const QString &name)
{
    int row = -1;
    int lookedAtRow = 0;
    for(auto& img : mImageList){
         if(img->name() == name){
            row = lookedAtRow;
        }
        ++lookedAtRow;
    }
    QModelIndex changedIndex = index(row, 0);
    emit dataChanged(changedIndex,changedIndex);
}

ImageSounds::ImageSounds(const QString &name): QObject(nullptr),
    mName(name)
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
    emit dataChanged(mName);
}

QStringList ImageSounds::imgSounds() const
{
    return mImgSounds;
}

void ImageSounds::setImgSounds(const QStringList &imgSounds)
{
    mImgSounds = imgSounds;
    emit dataChanged(mName);
}

void ImageSounds::setImgSounds(const QString &imgSounds)
{
    mImgSounds = imgSounds.split(" ");
    emit dataChanged(mName);
}
