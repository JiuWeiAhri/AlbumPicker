//
//  HKAlumBrowerCell.swift
//  Taoyuejia
//
//  Created by AhriLiu on 2020/10/15.
//  Copyright © 2020 zxw. All rights reserved.
//

import UIKit
import YXKitOC

typealias browerBlockImageBlock = (_ isEdit: Bool) -> Void

class HKAlumBrowerCell: UICollectionViewCell {
    
    var browerType : HKAlbumBrowerType?
    var cellImageSelectBlock : ((_ imageArr : [UIImage]) -> Void)?

    private var imageblock: browerBlockImageBlock?
    private var isEdited: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        selfTapAction()
    }
    
    //MARK: - UI
    func configUI() {
        imageV.center = baseScrollView.center
        contentView.backgroundColor = .black
        contentView.addSubview(self.editImageV)
        contentView.addSubview(baseScrollView)
        baseScrollView.addSubview(imageV)
        contentView.addSubview(cropBtn)
        contentView.addSubview(replaceBtn)
        contentView.addSubview(escBtn)
    }
    
    func reloadBtnsUI() {
        switch self.browerType {
        case .onlyBrower:
            cropBtn.isHidden = true
            replaceBtn.isHidden = true
        case .autoClip:
            cropBtn.isHidden = true
            replaceBtn.isHidden = true
        case .preViewClip:
            cropBtn.isHidden = false
            replaceBtn.isHidden = true
        case .replace:
            self.cropBtn.isHidden = true
            self.replaceBtn.isHidden = false
        case .none:
            print("")
        }
    }
    //MARK: - reloadData
    
    func reloadCell(_ model: HKAlbumBrowerImageModel) {
        self.reloadBtnsUI()
        if model.imageUrl?.count ?? 0 > 0 {
            self.imageV.tc_setImage(with:model.imageUrl, useType: .carList)
        } else {
            self.imageV.image =  model.image
        }
    }
    
    //MARK: - Action
    /// 裁剪照片
    func proportionBtnAction (){
        if !self.isEdited {
            self.cropBtn.setTitle("确定", for:.normal)
            self.editImageV.resultImgSize = CGSize.init(width: 300, height: 200)
            self.editImageV.isHidden = false
            self.baseScrollView.isHidden = true
        } else {
            self.editImageV.isHidden = true
            self.baseScrollView.isHidden = false
            // 确定照片
            let image = achiveCelImage()
            if cellImageSelectBlock != nil {
                 cellImageSelectBlock!([image])
            }
        }
        self.isEdited = !self.isEdited
        if (self.imageblock != nil) {
            self.imageblock!(self.isEdited)
        }
    }
    /// 替换照片
    func replaceBtnAction() {
//        HKAlbumManager.share.showActionSheet(naviControl: (self.viewController()?.navigationController)!, selectType: .all)
    }
    
    func escBtnAction() {
        self.viewController()?.navigationController?.popViewController(animated: true)
    }
    
    func selfTapAction() {
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selfSingleTap(_:)))
        singleTap.numberOfTapsRequired = 1
        let doubleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(scrollerDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        singleTap.require(toFail: doubleTap)
        let longTap: UILongPressGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(selfLongTap))
        
        contentView.addGestureRecognizer(singleTap)
        contentView.addGestureRecognizer(longTap)
        self.baseScrollView.addGestureRecognizer(doubleTap)
    }
    
    @objc func selfSingleTap(_ tap: UITapGestureRecognizer) {
        
    }
    
    @objc func scrollerDoubleTap(_ tap: UITapGestureRecognizer) {
        if baseScrollView.zoomScale > HKAlbumManager.share.previewMinScale {
            baseScrollView.setZoomScale(HKAlbumManager.share.previewMinScale, animated: true)
        } else {
            let touchPoint: CGPoint = tap.location(in: imageV)
            let newZoomScale = self.baseScrollView.maximumZoomScale
            let xSize = self.width / newZoomScale
            let ySize = self.height / newZoomScale
            self.baseScrollView.zoom(to: CGRect(x: touchPoint.x - xSize/2,
                                                y: touchPoint.y - ySize/2,
                                                width: xSize,
                                                height: ySize),
                                     animated: true)
        }
    }
    
    @objc func selfLongTap() {
        
    }
    
    // MARK: - Method
    func imageVtoCenterMethod() {
        let boundSize = self.baseScrollView.bounds.size
        var contentFrame = self.imageV.frame
        contentFrame.origin.x = contentFrame.width < boundSize.width ? (boundSize.width - contentFrame.width)/2 : 0
        contentFrame.origin.y = contentFrame.height < boundSize.height ? (boundSize.height - contentFrame.height)/2 : 0
        imageV.frame = contentFrame
    }
    
    func resetZoomScrollView()  {
        baseScrollView.setZoomScale(HKAlbumManager.share.previewMinScale, animated: true)
        baseScrollView.center = contentView.center
        imageV.center = baseScrollView.center
    }
    
    func achiveCelImage()-> UIImage {
        let corpImg = self.editImageV.clipImg()
        return corpImg
    }
    
    // MARK: - block
    func imageBlock(block: @escaping (_ isEdit: Bool) -> Void) {
        imageblock = block
    }
    
    //MARK: - getter
    lazy var editImageV: HKAlbumCropView = {
        let cropView = HKAlbumCropView(frame: CGRect(x: 0, y: YX_StatusBar_H(), width: self.contentView.width, height: self.contentView.height))
        cropView.type = HKAlbumManager.share.cropType
        cropView.isHidden = true
        return cropView
    }()
    
    lazy var baseScrollView : UIScrollView = {
        return UIScrollView(frame: self.bounds)
            .maximumZoomScale(HKAlbumManager.share.previewMaxScale)
            .minimumZoomScale(HKAlbumManager.share.previewMinScale)
            .multipleTouchEnabled(enabled: true)
            .scrollsToTop(false)
            .showsHorizontalScrollIndicator(false)
            .showsVerticalScrollIndicator(true)
            .delaysContentTouches(false)
            .canCancelContentTouches(true)
            .alwaysBounceVertical(false)
            .bouncesZoom(false)
            .bounces(false)
            .backgroundColor(.black)
            .config { (scroll) in
                scroll.delegate = self
        }
    }()
    
    lazy var imageV : UIImageView = {
        return UIImageView(frame: self.bounds)
            .contentMode(.scaleAspectFit)
            .userInteractionEnabled(enabled: true)
            .backgroundColor(.black)
    }()
    
    lazy var replaceBtn: UIButton = {
        return  UIButton(frame: CGRect(x: self.contentView.width - 80, y: self.contentView.top + 50, width: 60, height: 30))
            .title("替换", color: .white, for: .normal)
            .clipsToBounds(true)
            .addAction(.touchUpInside) { (btn) in
                btn.layer.cornerRadius = 20
                self.replaceBtnAction()
        }
    }()
    
    lazy var escBtn: UIButton = {
        return  UIButton(frame: CGRect(x: 0, y: self.contentView.top + 20, width: 60, height: 60))
            .clipsToBounds(true)
            .config(config: { (btn) in
                btn.setImage(UIImage(named: "closeX"), for: .normal)
            })
            .addAction(.touchUpInside) { (btn) in
                self.escBtnAction()
        }
    }()
    
    lazy var cropBtn: UIButton = {
        return  UIButton(frame: CGRect(x: self.width - 80, y: self.contentView.height - 50, width: 60, height: 30))
            .title("裁剪", color: .white, for: .normal)
            .clipsToBounds(true)
            .addAction(.touchUpInside) { (btn) in
                btn.layer.cornerRadius = 20
                self.proportionBtnAction()
        }
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HKAlumBrowerCell: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageV
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        imageVtoCenterMethod()
    }
    
    
}
