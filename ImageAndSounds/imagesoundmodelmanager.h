#ifndef IMAGESOUNDMODELMANAGER_H
#define IMAGESOUNDMODELMANAGER_H

#include <QObject>
#include <memory>

#include "imagesoundsmodel.h"

class ImageSoundModelManager : public QObject
{
    Q_OBJECT
public:
    explicit ImageSoundModelManager(QObject *parent = nullptr);
    ImageSoundsModel* getModel() const;
private:
    void initModel();
    std::unique_ptr<ImageSoundsModel> mModel;

};

#endif // IMAGESOUNDMODELMANAGER_H