#ifndef IMAGESOUNDSMODEL_H
#define IMAGESOUNDSMODEL_H

#include <QAbstractListModel>
#include <QStringList>
#include "lettermodels_global.h"

class LETTERMODELSSHARED_EXPORT ImageSounds : public QObject {
    Q_OBJECT
public:
    ImageSounds(const QString& name);
    ImageSounds(const ImageSounds& ) = default;
    QString name() const;
    QString imgPath() const;
    void setImgPath(const QString &imgPath);

    QStringList imgSounds() const;
    void setImgSounds(const QStringList &imgSounds);
    void setImgSounds(const QString& imgSounds);
signals:
    void dataChanged(const QString& name);
private:
    QString mName;
    QString mImgPath;
    QStringList mImgSounds;
};

class LETTERMODELSSHARED_EXPORT ImageSoundsModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum ImgRoles {
            NameRole = Qt::UserRole + 1,
            FilePathRole,
            SoundsRole
        };
    explicit ImageSoundsModel();
    virtual ~ImageSoundsModel() override;
    ImageSounds &addImage(const QString& name);
    ImageSounds &getImage(const QString& name);
    bool hasImage(const QString& name)const;
    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    Q_INVOKABLE QVariant data(const QModelIndex& index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
private slots:
    void imageHasChanged(const QString& name);
signals:
private:
    QList<ImageSounds*> mImageList;
};

#endif // IMAGESOUNDSMODEL_H
