//
//  HKAlbumCollectionCell.swift
//  Taoyuejia
//
//  Created by AhriLiu on 2020/10/15.
//  Copyright © 2020 zxw. All rights reserved.
//

import UIKit

typealias cellImageClickBlock = () -> Void

class HKAlbumCollectionCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.isUserInteractionEnabled = true
        contentView.addSubview(imgV)
        contentView.addSubview(selectImageV)
    }
    
    private var cellImageBlock : cellImageClickBlock?
    // MARK: - select Action
    open override var isSelected: Bool {
        didSet{
            if isSelected {
                selectImageV.image = UIImage.init(named: "CellBlueSelected")
            }else{
                selectImageV.image = UIImage.init(named: "CellGreySelected")
            }
        }
    }
    
    func cellImageViewClickBlock(_ block: @escaping () -> Void) {
        cellImageBlock = block
    }
    
    @objc private func imageTapAction() {
        if self.cellImageBlock != nil {
            self.cellImageBlock!()
        }
    }
    
    func playAnimate() {
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: .allowUserInteraction,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2,
                                                       animations: {
                                                        self.selectImageV.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.4,
                                                       animations: {
                                                        self.selectImageV.transform = CGAffineTransform.identity
                                    })
        }, completion: nil)
    }
    
    // MARK: - getter
    
    lazy var imgV : UIImageView = {
        let imageV = UIImageView.init(frame: CGRect(x: 0, y: 0, width: self.contentView.width, height: self.contentView.height))
        imageV.contentMode = .scaleAspectFill
        imageV.clipsToBounds = true
        imageV.isUserInteractionEnabled = true
        
        let tapV = UIView(frame: CGRect(x: 0, y: 40, width: imageV.width - 40, height: imageV.height - 40))
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(imageTapAction))
        tapV.addGestureRecognizer(tap)
        imageV.addSubview(tapV)
        
        return imageV
    }()
    
    lazy var selectImageV : UIImageView = {
        
        let imageV = UIImageView.init(frame: CGRect(x: self.contentView.width - 35, y: 5, width: 30, height: 30))
        imageV.contentMode = .scaleAspectFill
        imageV.isUserInteractionEnabled = true
        imageV.clipsToBounds = true
        imageV.image = UIImage.init(named: "CellGreySelected")
        
        return imageV
    }()
    
    
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
