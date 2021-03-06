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
import SKPhotoBrowser
import PopMenu

class LostAndFoundVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var losts: [LostAndFound] = []
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
        getLostAndFound()
    }
    
    private func initUI() {
        title = "失物招领"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "arrow_down"), style: .plain, target: self, action: #selector(showMore))
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
        
        collectionView.mj_footer = MJRefreshBackStateFooter { [weak self] in
            self?.loadMore()
            self?.collectionView.mj_footer.endRefreshing()
        }
        
        // 流式布局设置
        let itemWidth = (ScreenWidth - 30) / 2
        let itemHeight = CGFloat(350)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
    }

    
    private func getLostAndFound() {
        currentPage = 1
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/lostandfound/split?page=1", headers: headers).responseJSON { [weak self] response in
            if let self = self {
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.losts.removeAll()
                    self.images.removeAll()
                    // json是数组
                    for (_, subJson):(String, JSON) in json {
                        let lost = LostAndFound(jsonData: subJson)
                        self.losts.append(lost)
                        let photo = SKPhoto.photoWithImageURL(baseURL + (lost.imageURL?.first ?? "/image/lostandfound/default.png"))
                        photo.caption = lost.content
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
        Alamofire.request(baseURL + "/api/v1/lostandfound/split?page=\(currentPage)", headers: headers).responseJSON { [weak self]  response in
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
                        let lost = LostAndFound(jsonData: subJson)
                        self.losts.append(lost)
                        let photo = SKPhoto.photoWithImageURL(baseURL + (lost.imageURL?.first ?? "/image/lostandfound/default.png"))
                        photo.caption = lost.content
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
    
    private func goPostThing() {
        let postLostAndFoundVC = PostLostAndFoundVC()
        navigationController?.pushViewController(postLostAndFoundVC, animated: true)
    }
    
    @objc private func showMore() {
        let manager = PopMenuManager.default
        manager.popMenuDelegate = self
        manager.actions = [
            PopMenuDefaultAction(title: "发布失物", image: #imageLiteral(resourceName: "send")),
            PopMenuDefaultAction(title: "我的失物", image: #imageLiteral(resourceName: "search")),
        ]
        manager.present(sourceView: navigationItem.rightBarButtonItem)
    }
    
}

extension LostAndFoundVC: PopMenuViewControllerDelegate {
    
    func popMenuDidSelectItem(_ popMenuViewController: PopMenuViewController, at index: Int) {
        switch index {
        case 0:
            goPostThing()
        case 1:
            let myLostVC = MyLostVC()
            navigationController?.pushViewController(myLostVC, animated: true)
        default:
            print("错误选项")
        }
    }
    
}


extension LostAndFoundVC: LostAndFoundCellDelegate {
    func sendMessageTo(userID: Int) {
        let sendToUserMsgVC = SendToUserMsgVC()
        sendToUserMsgVC.toUserID = userID
        navigationController?.pushViewController(sendToUserMsgVC, animated: true)
    }
}

extension LostAndFoundVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(indexPath.item)
        present(browser, animated: true, completion: {})
    }
}

extension LostAndFoundVC: UICollectionViewDataSource {    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return losts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LostAndFoundCell", for: indexPath) as! LostAndFoundCell
        cell.delegate = self
        cell.setupModel(losts[indexPath.item])
        return cell
    }
}
