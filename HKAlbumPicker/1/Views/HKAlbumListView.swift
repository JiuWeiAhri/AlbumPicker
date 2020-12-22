//
//  HKAlbumListView.swift
//  Taoyuejia
//
//  Created by AhriLiu on 2020/11/2.
//  Copyright © 2020 zxw. All rights reserved.
//

import UIKit
import Photos
import YXKitOC

typealias albumListSelectBlock = (_ albumItem: HKAlbumImageItem) -> Void

class HKAlbumListView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        self.addSubview(self.tableView)
    }

    lazy var dataSource :[HKAlbumImageItem] = []
    private var selectedBlock : albumListSelectBlock?
    func albumListClickBlock(_ block: @escaping (_ albumItem: HKAlbumImageItem) -> Void) {
        self.selectedBlock = block
    }
    
    /// 获取相册列表
    func achiveAlbumList() {
        PHPhotoLibrary.requestAuthorization({ (status) in
            if status != .authorized {
                return
            }
            self.dataSource.removeAll()
            let smartOptions = PHFetchOptions()
            let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: smartOptions)
            for i in 0..<smartAlbums.count{
                let resultsOptions = PHFetchOptions()
                resultsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                                   ascending: false)]
                resultsOptions.predicate = NSPredicate(format: "mediaType = %d",
                                                       PHAssetMediaType.image.rawValue)
                let c = smartAlbums[i]
                let assetsFetchResult = PHAsset.fetchAssets(in: c , options: resultsOptions)
                if assetsFetchResult.count > 0 {
                    let title = self.titleOfAlbumForChinse(title: c.localizedTitle)
                    self.dataSource.append(HKAlbumImageItem(title: title,
                                                            fetchResult: assetsFetchResult))
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    private func titleOfAlbumForChinse(title:String?) -> String? {
        if title == "Slo-mo" {
            return "慢动作"
        } else if title == "Recently Added" {
            return "最近添加"
        } else if title == "Favorites" {
            return "个人收藏"
        } else if title == "Recently Deleted" {
            return "最近删除"
        } else if title == "All Photos" {
            return "所有照片"
        } else if title == "Selfies" {
            return "自拍"
        } else if title == "Screenshots" {
            return "屏幕快照"
        } else if title == "Camera Roll" {
            return "相机胶卷"
        }
        return title
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView().frame(CGRect(x: 0, y: 0, width: YX_AppW(), height: 400))
            .backgroundColor(HKColorManager.separator)
            .config { (tab) in
                tab.delegate = self
                tab.dataSource = self
                tab.separatorStyle = .none
                tab.register(HKAlbumListCell.self, forCellReuseIdentifier: "HKAlbumListCell")
        }
        return tableView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HKAlbumListView : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HKAlbumListCell = tableView.dequeueReusableCell(withIdentifier: "HKAlbumListCell") as! HKAlbumListCell
        let item = dataSource[indexPath.row]
        cell.reloadCellByData(item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSource[indexPath.row]
        if self.selectedBlock != nil {
            self.selectedBlock!(item)
        }
    }
    
}
