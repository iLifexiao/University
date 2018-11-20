//
//  IdleGoodVC.swift
//  University
//
//  Created by 肖权 on 2018/11/14.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class IdleGoodVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let idleCell = "idleCell"
    var idleGoods: [IdleGood] = []
    
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
        getIdleGoods()
    }
    
    private func initUI() {
        title = "校园闲鱼"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "send"), style: .plain, target: self, action: #selector(goPostThing))
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib.init(nibName: "IdleGoodCell", bundle: nil), forCellWithReuseIdentifier: idleCell)
        
        // 下拉刷新
        collectionView.mj_header = MJRefreshNormalHeader { [weak self] in
            // 重新获取
            self?.getIdleGoods()
            
            self?.collectionView.mj_header.endRefreshing()
            self?.view.makeToast("刷新成功", position: .top)
        }
    }
        
    private func getIdleGoods() {
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/idlegood/all", headers: headers).responseJSON { [weak self] response in
            if let self = self {
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.idleGoods.removeAll()
                    // json是数组
                    for (_, subJson):(String, JSON) in json {
                        self.idleGoods.append(IdleGood(jsonData: subJson))
                    }
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.collectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    @objc func goPostThing() {
        let postIdleGoodVC = PostIdleGoodVC()
        navigationController?.pushViewController(postIdleGoodVC, animated: true)
    }    
}

extension IdleGoodVC: UICollectionViewDelegate {
    
}

extension IdleGoodVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return idleGoods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idleCell, for: indexPath) as! IdleGoodCell
        cell.setupModel(idleGoods[indexPath.row])
        return cell
    }
}
