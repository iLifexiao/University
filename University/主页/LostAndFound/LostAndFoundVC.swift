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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "send"), style: .plain, target: self, action: #selector(goPostThing))
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib.init(nibName: "LostAndFoundCell", bundle: nil), forCellWithReuseIdentifier: "LostAndFoundCell")
        
        // 下拉刷新
        collectionView.mj_header = MJRefreshNormalHeader { [weak self] in
            // 重新获取
            self?.getLostAndFound()
            
            self?.collectionView.mj_header.endRefreshing()
            self?.view.makeToast("刷新成功", position: .top)
        }
    }

    
    private func getLostAndFound() {
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/lostandfound/sort", headers: headers).responseJSON { [weak self] response in
            if let self = self {
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.losts.removeAll()
                    // json是数组
                    for (_, subJson):(String, JSON) in json {
                        self.losts.append(LostAndFound(jsonData: subJson))
                    }
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.collectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    @objc private func goPostThing() {
        let postLostAndFoundVC = PostLostAndFoundVC()
        navigationController?.pushViewController(postLostAndFoundVC, animated: true)
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
