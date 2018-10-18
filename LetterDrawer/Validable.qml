import QtQuick 2.0

Image {
    id: check
    source: "img/check.png"
    visible: parent.validated === undefined ? false : parent.validated;
    anchors.right: parent.right
    width: 0.33 * parent.width
    fillMode: Image.PreserveAspectFit
}

