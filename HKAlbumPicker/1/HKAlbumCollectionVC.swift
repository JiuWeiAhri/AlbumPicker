//
//  HKAlbumCollectionVC.swift
//  Taoyuejia
//
//  Created by AhriLiu on 2020/10/15.
//  Copyright © 2020 zxw. All rights reserved.
//

import UIKit
import Photos
import YXKitOC

typealias albumDissBlock = () -> Void

class HKAlbumCollectionVC: UIViewController, PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
    }
    
    private var albumDissBlock : albumDissBlock?
    private var isClickTop : Bool = false

    var imageSelectBlock   : ((_ imageArr: [UIImage]) -> Void)?
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        achiveAllPhotos()
        self.imageManager = PHCachingImageManager()
        self.resetCachedAssets()
        self.configUI()
        self.collectionV.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        titleView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleView.isHidden = false
    }
    
    //MARK:- block
    func albumDisMisssBlock(_ block:@escaping () -> Void) {
          albumDissBlock = block
      }
    
    // MARK: - UI
    func configUI() {
        let rightBarItem = UIBarButtonItem(title: "取消", style: .plain,
                                           target: self, action: #selector(cancel))
        self.navigationItem.rightBarButtonItem = rightBarItem
        self.view.backgroundColor = .lightGray
        self.view.addSubview(collectionV)
        self.view.addSubview(bottomView)
        titleView.addSubview(titleLabel)

        self.navigationController?.navigationBar.addSubview(titleView)
        self.view.addSubview(albumListView)
    }
    
    // MARK: - Method
    
    func achiveAllPhotos() {
        if self.assetsFetchResults == nil {
            PHPhotoLibrary.shared().register(self)
            let allOptions = PHFetchOptions()
            allOptions.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: false)]
            self.assetsFetchResults  = PHAsset.fetchAssets(with: allOptions)
        }
    }
    
    func resetCachedAssets(){
        self.imageManager.stopCachingImagesForAllAssets()
    }
    
    func selectedCount() -> Int {
        return self.collectionV.indexPathsForSelectedItems?.count ?? 0
    }
    
    // MARK: - Action
    //
    func albumListAction() {
        UIView.animate(withDuration: 0.5) {
            self.albumListView.top = 64
            self.litteImagV.image("up_gray")
        }
        
        albumListView.albumListClickBlock { [weak self](item) in
            guard let self = self else { return }
        
            self.titleLabel.text = item.title
            self.assetsFetchResults = item.fetchResult
            self.collectionV.reloadData()
            self.titleLabel.sizeToFit()
            self.titleView.frame(YX_AppW()/2 - self.titleView.width/2, 10, self.titleLabel.width + 45, 30)
            self.titleLabel.frame(20, 0, self.titleLabel.width, 30)
            self.litteImagV.frame(self.titleView.width - 25, 5, 20, 20)
            
            UIView.animate(withDuration: 0.3) {
                self.albumListView.top = -YX_AppH()
                self.litteImagV.image("down_gray")
            }
            self.isClickTop = !self.isClickTop
        }
        
        if self.isClickTop {
            UIView.animate(withDuration: 0.3) {
                self.albumListView.top = -YX_AppH()
                self.litteImagV.image("down_gray")
            }
        }
        self.isClickTop = !self.isClickTop
    }
    
    @objc func cancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func finishSelect(){
        var resultImgArr: [UIImage] = []
        if let indexPaths = self.collectionV.indexPathsForSelectedItems{
            for indexPath in indexPaths{
                let asset = assetsFetchResults![indexPath.row]
                let cacheImgManager = PHImageManager()
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                options.version = .current
                cacheImgManager.requestImageData(for: asset, options: options) { (imageData, dataUII, orientation, info) in
                    if imageData != nil {
                        let image = UIImage(data: imageData!)
                        resultImgArr.append(image!)
                    }
                }
            }
        }
        DispatchQueue.main.async {
            if self.imageSelectBlock != nil {
                self.imageSelectBlock!(resultImgArr)
            }
            self.navigationController?.popViewController(animated: true)
            if self.albumDissBlock != nil {
                self.albumDissBlock!()
            }
        }
    }
    
    func previewBtnAction() {
        self.imageDataArr.removeAll()
        if let indexPaths = self.collectionV.indexPathsForSelectedItems{
            for indexPath in indexPaths{
                let cacheImgManager = PHImageManager()
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                options.version = .current
                let asset = assetsFetchResults![indexPath.row]
                cacheImgManager.requestImageData(for: asset, options: options) { (imageData, dataUII, orientation, info) in
                    if imageData != nil {
                        let image = UIImage(data: imageData!)
                        let model = HKAlbumBrowerImageModel()
                        model.image = image
                        self.imageDataArr.append(model)
                    }
                }
            }
        }
        DispatchQueue.main.async {
            if self.imageDataArr.count > 0 {
                let browerVC = HKAlbumBrowerVC()
                browerVC.dataSource = self.imageDataArr
                self.navigationController?.pushViewController(browerVC, animated: true)            }
        }
    }
    
    // MARK: - getter
    var assetsFetchResults : PHFetchResult<PHAsset>?
    var imageManager : PHCachingImageManager!//带缓存的图片管理对象
    var assetGridThumbnailSize : CGSize!
    var completeHandler: ((_ assets: [PHAsset])->())?
    private var imageDataArr: [HKAlbumBrowerImageModel] = []
    
    lazy var albumListView: HKAlbumListView = {
        let view = HKAlbumListView().frame(0, -YX_AppH(), YX_AppW(), YX_AppH())
        view.achiveAlbumList()
        return view
    }()
    
    lazy var completeBtn: HKImageCompleteButton = {
        let btn = HKImageCompleteButton()
        btn.center = CGPoint(x: UIScreen.main.bounds.width - 50, y: 25)
        btn.isEnabled = false
        btn.backgroundColor = HKColorManager.blue
        btn.titleLabel.textColor = .white
        btn.yx_setCornerRadius(btn.height/2)
        btn.addTarget(target: self, action: #selector(finishSelect))
        return btn
    }()
    
    lazy var previewBtn: UIButton = {
        return UIButton(frame: CGRect(x: 15, y: 0, width: 70, height: 50))
            .font(fontSize: 15)
            .title("预览", color: .black, for: .normal)
            .isEnabled(false)
            .addAction(.touchUpInside) { (btn) in
                self.previewBtnAction()
        }
    }()
    
    lazy var bottomView: UIView = {
        return UIView(frame: CGRect(x: 0, y: self.view.height - 50, width: YX_AppW(), height: 50))
            .backgroundColor(.white)
            .config { (view) in
                view.addSubview(self.previewBtn)
                view.addSubview(self.completeBtn)
        }
    }()
    
    lazy var collectionV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width/4,
                                 height: UIScreen.main.bounds.size.width/4)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height - self.bottomView.height), collectionViewLayout: layout)
            .config { (co) in
                co.allowsMultipleSelection = true
                co.backgroundColor = YX_Color16(0xF5F7F5)//UIColor.doraemon_color(withHex: 0xF5F7F5)
                co.delegate = self
                co.dataSource = self
                co.register(HKAlbumCollectionCell.self, forCellWithReuseIdentifier: "HKAlbumCollectionCell")
        }
    }()
    
    lazy var titleView : UIView = {
        return UIView(frame: CGRect(x: YX_AppW()/2-60, y: 10, width: 120, height: 30))
            .backgroundColor(.lightGray)
            .config { [weak self](view) in
                guard let self = self  else { return}
                view.yx_cornerRadius = view.height/2
                view.addSubview(self.litteImagV)
                view.yx_addTappedBlock {
                    self.albumListAction()
                }
        }
    }()
    
    lazy var litteImagV : UIImageView = {
        return  UIImageView().frame(93, 5, 20, 20)
            .userInteractionEnabled(enabled: true).image("down_gray")
    }()
    
    lazy var titleLabel : UILabel = {
        return UILabel(frame: CGRect(x: 0, y: 0, width: self.titleView.width - 15, height: self.titleView.height))
            .text("最近项目")
            .textColor(.white)
            .textAlignment(.center)
    }()
    
    // MARK: -deinit
    deinit {
        print("deinit ---- \(self)")
    }
}

// MARK: - UICollectionViewDataSource,UICollectionViewDelegate
extension HKAlbumCollectionVC:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assetsFetchResults?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HKAlbumCollectionCell",
                                                      for: indexPath) as! HKAlbumCollectionCell
        let asset = self.assetsFetchResults![indexPath.row]
        self.imageManager.requestImage(for: asset,
                                       targetSize: CGSize(width: YX_AppW()/4, height: YX_AppW()/4),
                                       contentMode: .aspectFill, options: nil) {
                                        (image, nfo) in
                                        cell.imgV.image = image
        }
        cell.cellImageViewClickBlock {
            let cacheImgManager = PHImageManager()
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            options.version = .current
            cacheImgManager.requestImageData(for: asset, options: options) { (imageData, dataUII, orientation, info) in
                if imageData != nil {
                    let image = UIImage(data: imageData!)
                    let model = HKAlbumBrowerImageModel()
                    model.image = image
                    let browerVC = HKAlbumBrowerVC()
                    browerVC.dataSource = [model]
                    self.navigationController?.pushViewController(browerVC, animated: true)
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let count = self.selectedCount()
        if count > HKAlbumManager.share.maxSelected {
            collectionView.deselectItem(at: indexPath, animated: false)
            let title = "你最多只能选择\(HKAlbumManager.share.maxSelected)张照片"
            let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title:"我知道了", style: .cancel, handler:nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            completeBtn.num = count
            if count > 0 && !self.completeBtn.isEnabled{
                completeBtn.isEnabled = true
                previewBtn.isEnabled(true)
            }
        }
        
        if count == 1 &&  HKAlbumManager.share.maxSelected == 1 {
            self.finishSelect()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

            let count = self.selectedCount()
            completeBtn.num = count
            if count == 0{
                completeBtn.isEnabled = false
                previewBtn.isEnabled(false)
            }
    }
}
// MARK: - 完成按钮View CompleteView

class HKImageCompleteButton: UIView {
    var numLabel : UILabel!
    var titleLabel : UILabel!
    let defaultFrame = CGRect(x:0, y:0, width:70, height:31)
    var tapSingle:UITapGestureRecognizer?
    var num:Int = 0{
        didSet{
            if num == 0{
                titleLabel.text =  "发送"
            } else {
                titleLabel.text =  "发送(\(num))"
            }
        }
    }
    //是否可用
    var isEnabled:Bool = true {
        didSet{
            if isEnabled {
                tapSingle?.isEnabled = true
                self.titleLabel.backgroundColor = HKColorManager.blue
            }else{
                self.titleLabel.backgroundColor = .lightGray
                tapSingle?.isEnabled = false
            }
        }
    }
    
    init(){
        super.init(frame:defaultFrame)
        titleLabel = UILabel(frame:CGRect(x: 0 , y: 0 ,
                                          width: defaultFrame.width,
                                          height: 31))
        titleLabel.text = "发送"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = .white
        titleLabel.backgroundColor = .lightGray
        self.addSubview(titleLabel)
    }
    
    func playAnimate() {
        self.numLabel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5, options: UIView.AnimationOptions(),
                       animations: {
                        self.numLabel.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    func addTarget(target: Any?, action: Selector?) {
        //单击监听
        tapSingle = UITapGestureRecognizer(target:target,action:action)
        tapSingle!.numberOfTapsRequired = 1
        tapSingle!.numberOfTouchesRequired = 1
        self.addGestureRecognizer(tapSingle!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        print("deinit ---- \(self)")
    }
    
}

