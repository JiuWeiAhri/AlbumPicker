//
//  HKAlbumManager.swift
//  Taoyuejia
//
//  Created by AhriLiu on 2020/10/14.
//  Copyright © 2020 zxw. All rights reserved.
//

import UIKit
import Photos
import YXKitOC

struct HKAlbumImageItem {
    var title : String?
    var fetchResult:PHFetchResult<PHAsset>
}

class HKAlbumBrowerImageModel {
    var image : UIImage?
    var index : NSInteger?
    var imageUrl : String?
    
//    static func toAlbumBrowerImageModel(_ albumM : TCAlbumPhotoModel) -> HKAlbumBrowerImageModel {
//        let browerM = HKAlbumBrowerImageModel()
//        browerM.imageUrl = albumM.url
//        browerM.image = albumM.image
//        return browerM
//    }
}

enum HKAlbumBrowerType {
    /// 自动裁剪
    case autoClip
    /// 预览裁剪
    case preViewClip
    /// 预览，不能编辑
    case onlyBrower
    /// 需要替换, 可以编辑
    case replace
}

enum HKAlbumSelectPhotoType {
    /// 拍照、相册选择
    case all
    /// 仅拍照
    case takePhoto
    /// 仅相册选择
    case album
}

enum HKAlbumCropType {
    case move
    case stay
}

class HKAlbumManager: NSObject {
    
    static let share = HKAlbumManager()
    /// 最大选择数量
    var maxSelected       :   Int = 1
    /// 是否需要上传
    var isNeedUpLoad      :   Bool = true
    /// 预览放大比例
    var previewMaxScale   :   CGFloat = 3.0
    /// 预览缩小比例
    var previewMinScale   :   CGFloat = 1.0
    /// 裁剪比例
    var cropRatio         :   (Int, Int) = (4, 3)
    /// 原图比例。1.默认false(可裁剪） 2.true 时（原图，不可裁剪~）
    var originalRatio     :   Bool = false
    /// 裁剪类型
    var cropType          :   HKAlbumCropType = .stay
    /// 照片浏览类型
    var browerType        :   HKAlbumBrowerType = .onlyBrower
    /// 选择照片来源
    var selectPhotoType   :   HKAlbumSelectPhotoType = .all
    
    // MARK: - 相册选择
    func showActionSheet(naviControl: UINavigationController,selectType:HKAlbumSelectPhotoType, imageSelectedBlock:@escaping((_ imageArr: [UIImage]) -> Void)) {
        let sheet: UIAlertController = UIAlertController(title: "选择照片", message:nil, preferredStyle: .actionSheet)
        
        switch selectType {
        case .all:
            self.selectFromTakePhoto(sheet, naviControl) { (imageArr) -> Void? in
                imageSelectedBlock(imageArr)
            }
            self.selectFromAlbum(sheet, naviControl) { (imageArr) -> Void? in
                imageSelectedBlock(imageArr)
            }
            
        case .album:
            self.selectFromAlbum(sheet, naviControl) { (imageArr) -> Void? in
                imageSelectedBlock(imageArr)
            }
            
        case .takePhoto:
            self.selectFromTakePhoto(sheet, naviControl) { (imageArr) -> Void? in
                imageSelectedBlock(imageArr)
            }
        }
        sheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action:UIAlertAction) in
            naviControl.dismiss(animated: true, completion: nil)
        }))
        naviControl.present(sheet, animated: true, completion: nil)
    }
    
    // MARK: - 私有方法
    private func selectFromAlbum(_ actSheet : UIAlertController, _ navi : UINavigationController,_ imageArr:@escaping([UIImage])->Void?) {
        actSheet.addAction(UIAlertAction(title: "从相册选择", style: .default, handler: { (action:UIAlertAction) in
            let vc = HKAlbumCollectionVC()
            vc.imageSelectBlock = {(dataArr) in
                var newResultArr = [UIImage]()
                if !HKAlbumManager.share.originalRatio{
                    for newImage in dataArr {
                        let tempImg = newImage.crop(HKAlbumManager.share.cropRatio)
                        newResultArr.append(tempImg)}
                } else {
                    newResultArr = dataArr
                }
                imageArr(newResultArr)
            }
            navi.pushViewController(vc, animated: true)
        }))
    }
    
    private func selectFromTakePhoto(_ actSheet : UIAlertController, _ navi : UINavigationController,_ imageArr:@escaping([UIImage])->Void?) {
        actSheet.addAction(UIAlertAction(title: "拍照", style: .default, handler: { (action:UIAlertAction) in
            let vc = HKAlbumCameraVC()
            vc.imageSelectBlock = {(dataArr) in
                var newResultArr = [UIImage]()
                if !HKAlbumManager.share.originalRatio {
                    for newImage in dataArr {
                        let tempImg = newImage.crop(HKAlbumManager.share.cropRatio)
                        newResultArr.append(tempImg)}
                } else {
                    newResultArr = dataArr
                }
                imageArr(newResultArr)
            }
            navi.pushViewController(vc, animated: true)
        }))
    }
    
    /// 展示图片详情
    func browerPhotoDetailUrlArr(_ imageArr: [String], _ navi: UINavigationController) {
        var dataSource : [HKAlbumBrowerImageModel] = []
        for imageUrl in imageArr {
            let model = HKAlbumBrowerImageModel()
            model.imageUrl = imageUrl
            dataSource.append(model)
        }
        self.jumpIntoBrowVC(dataSource, navi)
    }
    
//    func browerPhotoDetailModelArr(_ photoModelArr : [TCAlbumPhotoModel], _ navi : UINavigationController) {
//        var resultArr : [HKAlbumBrowerImageModel] = []
//        for (_, albumM) in photoModelArr.enumerated() {
//            let browerM = HKAlbumBrowerImageModel()
//            browerM.imageUrl = albumM.url
//            browerM.image = albumM.image
//            resultArr.append(browerM)
//        }
//        self.jumpIntoBrowVC(resultArr, navi)
//    }
    
    func browerPhotoDetailBrowerArr(_ photoModelArr : [HKAlbumBrowerImageModel], _ navi : UINavigationController) {
        self.jumpIntoBrowVC(photoModelArr, navi)
    }
    
    private func jumpIntoBrowVC(_ dataArr : [HKAlbumBrowerImageModel], _ navi : UINavigationController) {
        let vc = HKAlbumBrowerVC()
        vc.dataSource = dataArr
        navi.pushViewController(vc, animated: true)
    }
    
}


extension UIImage {
    func crop(_ scale: (Int, Int)) -> UIImage {
        let ratio : CGFloat = CGFloat(scale.0)/CGFloat(scale.1)
        var newSize: CGSize!
        if size.width/size.height > ratio {
            newSize = CGSize(width: size.height * ratio, height: size.height)
        }else{
            newSize = CGSize(width: size.width, height: size.width / ratio)
        }
        ////图片绘制区域
        var rect = CGRect.zero
        rect.size.width  = size.width
        rect.size.height = size.height
        rect.origin.x    = (newSize.width - size.width ) / 2.0
        rect.origin.y    = (newSize.height - size.height ) / 2.0
        
        UIGraphicsBeginImageContext(newSize)
        draw(in: rect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
}
