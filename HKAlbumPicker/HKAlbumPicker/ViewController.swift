//
//  ViewController.swift
//  HKAlbumPicker
//
//  Created by AhriLiu on 2020/12/22.
//  Copyright © 2020 AhriLiu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        
        
        let textImageV = UIImageView.init(frame: CGRect.init(x: 10, y: 100, width: 230, height: 230))
        textImageV.backgroundColor = .brown
        textImageV.isUserInteractionEnabled = true
        self.view.addSubview(textImageV)

        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickImageView))
        textImageV.addGestureRecognizer(tap)
    }


    @objc func clickImageView(){
        
        HKAlbumManager.share.cropRatio = (3,2)
        HKAlbumManager.share.maxSelected = 1
        HKAlbumManager.share.selectPhotoType = .all

        HKAlbumManager.share.showActionSheet(naviControl: self.navigationController!, selectType: HKAlbumManager.share.selectPhotoType) { (imageArr) in
           
        }
        

        
    }
    
    
    
}

