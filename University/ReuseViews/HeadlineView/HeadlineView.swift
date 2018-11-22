//
//  HeadlineView.swift
//  University
//
//  Created by 肖权 on 2018/10/24.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

@objc protocol HeadlineViewDelegate {
    func headlineView(_ headlineView: HeadlineView, didSelectItemAt index: Int)
}

class HeadlineView: UIView {
            
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    private var timer: Timer?
    private var news: [String] = []
    private var currentIndex = 0
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: "NewsCell", bundle: nil), forCellWithReuseIdentifier: "NewsCell")
    }
    
//    var autoScroll = true
//    var infiniteLoop = true
    // 开放属性
    var autoScrollTimeInterval = 3
    weak var delegate: HeadlineViewDelegate?
    
    // 计算属性
    var currentNewsIndex: Int {
        set {
            // 循环操作
            if newValue >= news.count {
                currentIndex = 0
                collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredVertically, animated: false)
            } else {
                currentIndex = newValue
                collectionView.scrollToItem(at: IndexPath(item: newValue, section: 0), at: .top, animated: true)
            }
        }
        get {
            return currentIndex
        }
    }
    
    // MARK: Set IconAndTitle
    func setIcon(_ icon: UIImage?) {
        guard icon != nil else { return }
        iconImageView.image = icon
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    // MARK: setNews
    func setNews(_ news: [String]) {
        // 每次设置都需要销毁Timer，导致叠加
        invalidateTimer()
        self.news = news
        collectionView.reloadData()
        setTimer()
    }
    
    private func setTimer() {
        timer = Timer(timeInterval: TimeInterval(autoScrollTimeInterval), target: self, selector: #selector(nextNews), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func nextNews() {
        currentNewsIndex += 1
    }
}

// MARK: UICollectionViewDelegate
extension HeadlineView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        if let delegate = self.delegate {
            delegate.headlineView(self, didSelectItemAt: index)
        }
    }
}

// MARK: UICollectionViewDataSource
extension HeadlineView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return news.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCell", for: indexPath) as! NewsCell
        cell.setNews(news[indexPath.row])
        return cell
    }
}

