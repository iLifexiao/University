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
import SKPhotoBrowser

class IdleGoodVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
//    let idleCell = "idleCell"
    var idleGoods: [IdleGood] = []
    var images: [SKPhoto] = []
    private var currentPage = 1
    
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
        collectionView.register(UINib.init(nibName: "IdleGoodCell", bundle: nil), forCellWithReuseIdentifier: "IdleGoodCell")
        
        // 下拉刷新
        collectionView.mj_header = MJRefreshNormalHeader { [weak self] in
            // 重新获取
            self?.getIdleGoods()
            
            self?.collectionView.mj_header.endRefreshing()
            self?.view.makeToast("刷新成功", position: .top)
        }
        collectionView.mj_footer = MJRefreshBackStateFooter { [weak self] in
            self?.loadMore()
            self?.collectionView.mj_footer.endRefreshing()
        }
    }
        
    private func getIdleGoods() {
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/idlegood/split?page=1", headers: headers).responseJSON { [weak self] response in
            if let self = self {
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.idleGoods.removeAll()
                    self.images.removeAll()
                    // json是数组
                    for (_, subJson):(String, JSON) in json {
                        let idleGood = IdleGood(jsonData: subJson)
                        self.idleGoods.append(idleGood)
                        let photo = SKPhoto.photoWithImageURL(baseURL + (idleGood.imageURLs?.first ?? "/image/Idlegoods/default.png"))
                        photo.caption = idleGood.content
                        self.images.append(photo)
                    }
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.collectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func loadMore() {
        currentPage += 1
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/idlegood/split?page=\(currentPage)", headers: headers).responseJSON { [weak self]  response in
            guard let self = self else {
                return
            }
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                // 加载完毕
                if json.count == 0 {
                    self.view.makeToast("没有更多了~", position: .top)
                } else {
                    for (_, subJson):(String, JSON) in json {
                        let idleGood = IdleGood(jsonData: subJson)
                        self.idleGoods.append(idleGood)
                        let photo = SKPhoto.photoWithImageURL(baseURL + (idleGood.imageURLs?.first ?? "/image/Idlegoods/default.png"))
                        photo.caption = idleGood.content
                        self.images.append(photo)
                    }
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    @objc func goPostThing() {
        let postIdleGoodVC = PostIdleGoodVC()
        navigationController?.pushViewController(postIdleGoodVC, animated: true)
    }    
}

extension IdleGoodVC: IdleGoodCellDelegate {
    func sendMessageTo(userID: Int) {
        let sendToUserMsgVC = SendToUserMsgVC()
        sendToUserMsgVC.toUserID = userID
        navigationController?.pushViewController(sendToUserMsgVC, animated: true)
    }
}

extension IdleGoodVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(indexPath.item)
        present(browser, animated: true, completion: {})
    }
}

extension IdleGoodVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return idleGoods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IdleGoodCell", for: indexPath) as! IdleGoodCell
        cell.delegate = self
        cell.setupModel(idleGoods[indexPath.item])
        return cell
    }
}
