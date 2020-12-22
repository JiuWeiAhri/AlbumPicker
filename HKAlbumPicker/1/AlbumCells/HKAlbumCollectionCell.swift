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
                selectImageV.image("CellBlueSelected")
            }else{
                selectImageV.image("CellGreySelected")
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
        return  UIImageView(frame: CGRect(x: 0, y: 0, width: self.contentView.width, height: self.contentView.height))
            .contentMode(.scaleAspectFill)
            .clipsToBounds(true)
            .userInteractionEnabled(enabled: true)
            .config { (imageV) in
                let tapV = UIView(frame: CGRect(x: 0, y: 40, width: imageV.width - 40, height: imageV.height - 40))
                let tap = UITapGestureRecognizer.init(target: self, action: #selector(imageTapAction))
                tapV.addGestureRecognizer(tap)
                imageV.addSubview(tapV)
        }
    }()
    
    lazy var selectImageV : UIImageView = {
        return  UIImageView(frame: CGRect(x: self.contentView.width - 35, y: 5, width: 30, height: 30))
            .contentMode(.scaleAspectFill)
            .userInteractionEnabled(enabled: true)
            .clipsToBounds(true)
            .config { (btn) in
                btn.image("CellGreySelected")
        }
    }()
    
    
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
