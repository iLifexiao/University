//
//  LostAndFoundVC.swift
//  University
//
//  Created by 肖权 on 2018/11/13.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class LostAndFoundVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var losts: [LostAndFound] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    private func initData() {
        getLostAndFound()
    }
    
    private func initUI() {
        title = "失物招领"
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib.init(nibName: "LostAndFoundCell", bundle: nil), forCellWithReuseIdentifier: "LostAndFoundCell")
        
        // 下拉刷新
        collectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            // 重新获取
            self.getLostAndFound()
            
            self.collectionView.mj_header.endRefreshing()
            self.view.makeToast("刷新成功", position: .top)
        })
    }

    
    private func getLostAndFound() {
        Alamofire.request(baseURL + "/api/v1/lostandfound/all", headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.losts.removeAll()
                // json是数组
                for (_, subJson):(String, JSON) in json {
                    self.losts.append(LostAndFound(jsonData: subJson))
                }
                self.collectionView.reloadData()                
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension LostAndFoundVC: UICollectionViewDelegate {
    
}

extension LostAndFoundVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return losts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LostAndFoundCell", for: indexPath) as! LostAndFoundCell
        cell.setupModel(losts[indexPath.row])
        return cell
    }
}
