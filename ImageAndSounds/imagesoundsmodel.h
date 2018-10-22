#ifndef IMAGESOUNDSMODEL_H
#define IMAGESOUNDSMODEL_H

#include <QAbstractListModel>
#include <QStringList>

class ImageSounds {
public:
    ImageSounds(const QString& name);
    QString name() const;
    QString imgPath() const;
    void setImgPath(const QString &imgPath);

    QStringList imgSounds() const;
    void setImgSounds(const QStringList &imgSounds);
    void setImgSounds(const QString& imgSounds);

private:
    QString mName;
    QString mImgPath;
    QStringList mImgSounds;
};

class ImageSoundsModel : public QAbstractListModel
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
    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
signals:
private:
    QList<ImageSounds> mImageList;
};

#endif // IMAGESOUNDSMODEL_H
