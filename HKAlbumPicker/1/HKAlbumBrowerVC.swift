//
//  HKAlbumBrowerVC.swift
//  Taoyuejia
//
//  Created by AhriLiu on 2020/10/15.
//  Copyright © 2020 zxw. All rights reserved.
//

import UIKit
import YXKitOC

class HKAlbumBrowerVC: UIViewController {
    
    //  MARK:-
    var dataSource : [HKAlbumBrowerImageModel] = []
    var browerType : HKAlbumBrowerType = HKAlbumManager.share.browerType
    private var currentImage: UIImage?
    private var isEidt: Bool = false
    private var currntIndex: Int = 0
    var imageSelectBlock   : ((_ imageArr: [UIImage]) -> Void)?
    
    // MARK:- LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        photoSelectBlockMethod()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK:- Method
    func showPhoto(_ imageArr : [HKAlbumBrowerImageModel])  {
        if imageArr.count > 0 {
            self.dataSource = imageArr
            self.collectionV.reloadData()
        }
    }

    func photoSelectBlockMethod() {
//        self.navigationController?.popViewController(animated: true)
    }
    // MARK:- UI
    func configUI() {
        self.view.addSubview(collectionV)
    }
    
    // MARK: - getter
    lazy var collectionV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.view.frame.size
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        return UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
            .config { (co) in
                co.allowsMultipleSelection = true
                co.backgroundColor = .black
                co.isPagingEnabled = true
                co.delegate = self
                co.dataSource = self
                co.register(HKAlumBrowerCell.self, forCellWithReuseIdentifier: "HKAlumBrowerCell")
        }
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK:-  UICollectionViewDelegate,UICollectionViewDataSource
extension HKAlbumBrowerVC: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HKAlumBrowerCell",
                                                      for: indexPath) as! HKAlumBrowerCell
        let model = dataSource[indexPath.row]
        cell.browerType = self.browerType
        cell.reloadCell(model)
        cell.imageBlock { [weak self](isEdit) in//
            guard let self = self else {return}
            self.collectionV.isScrollEnabled = !isEdit
            if !isEdit {
                self.navigationController?.navigationBar.isHidden = false
                self.navigationController?.yx_popViewController()
            }
        }
        cell.cellImageSelectBlock = {(imageArr) in
            self.imageSelectBlock!(imageArr)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    
}

