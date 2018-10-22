#include "imagesoundmodelmanager.h"

ImageSoundModelManager::ImageSoundModelManager(QObject *parent)
    : QObject(parent),
      mModel(std::make_unique<ImageSoundsModel>())
{
    initModel();
}

ImageSoundsModel *ImageSoundModelManager::getModel() const
{
    return mModel.get();
}

void ImageSoundModelManager::addImageSoundToModel(const QString &imageName)
{
    mModel->addImage(imageName);
}

void ImageSoundModelManager::initModel()
{
    for(auto name : {"bla", "blou", "blo", "blé"}){
        ImageSounds& img = mModel->addImage(name);
        img.setImgSounds(QStringList() << "b" << "l" << "a");
    }

}
