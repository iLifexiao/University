//
//  CountdownView.swift
//  University
//
//  Created by 肖权 on 2018/10/27.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

@objc protocol CountdownViewDelegate {
    func countdownView(_ countdownView: CountdownView, didSelectItemAt index: Int)
}

class CountdownView: UIView {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: CountdownViewDelegate?
    var countdowns: [CountdownModel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CountdownCell", bundle: nil), forCellWithReuseIdentifier: "CountdownCell")
    }

}

extension CountdownView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = self.delegate {
            delegate.countdownView(self, didSelectItemAt: indexPath.row)
        }
    }
}

extension CountdownView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countdowns.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CountdownCell", for: indexPath) as! CountdownCell
        cell.setupData(countdowns[indexPath.row])
        return cell
    }
    
    
}
