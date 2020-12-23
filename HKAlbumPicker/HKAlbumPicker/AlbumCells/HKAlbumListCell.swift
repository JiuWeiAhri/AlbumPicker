//
//  HKAlbumListCell.swift
//  Taoyuejia
//
//  Created by AhriLiu on 2020/10/14.
//  Copyright © 2020 zxw. All rights reserved.
//

import UIKit
import YXKitOC
import Photos

class HKAlbumListCell: UITableViewCell {
    
    private override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        configUI()
    }
    
    // MARK: - reloadCellData
    
    func reloadCellByData(_ model : HKAlbumImageItem)  {
        titleLabel.text = model.title
        countLabel.text = "(\(model.fetchResult.count))张"
        let asset = model.fetchResult[0]
        let cacheImgManager = PHCachingImageManager()
        cacheImgManager.requestImage(for: asset, targetSize: CGSize(width: 90, height: 90),
                                     contentMode: .aspectFill, options: nil) {
                                        (image, nfo) in
                                        self.coverImgV.image = image
        }
        titleLabel.sizeToFit()
        titleLabel.top = 25 - titleLabel.height/2
        countLabel.left = titleLabel.right
        
    }
    // MARK: - configUI
    
    func configUI() {
        contentView.backgroundColor = .white
        contentView.addSubview(titleLabel)
        contentView.addSubview(countLabel)
        contentView.addSubview(coverImgV)
        contentView.addSubview(bottomLine)
    }
    
    // MARK: - getter
    lazy var titleLabel : UILabel = {
        let label = UILabel.init(frame: CGRect(x: self.coverImgV.right + 15, y: 0, width: YX_AppW() - 30 , height: 49))
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    lazy var countLabel : UILabel = {
        let label = UILabel.init(frame: CGRect(x: titleLabel.right + 15, y: 0, width: YX_AppW() - 30, height: 49))
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = .gray
        return label
        
    }()
    
    lazy var coverImgV : UIImageView = {
        let imgV = UIImageView.init(frame: CGRect(x: 0, y: 1, width:48, height: 48))
        imgV.contentMode = .scaleAspectFit
        imgV.clipsToBounds = true
        return imgV
    }()
    
    lazy var bottomLine : UIView = {
        let view = UIView.init(frame: CGRect(x: 15, y: 49, width:YX_AppW()-30, height: 0.6))
        view.backgroundColor = .lightGray
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

