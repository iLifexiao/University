//
//  DetailRaceVC.swift
//  University
//
//  Created by 肖权 on 2018/11/13.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import MarkdownView

class DetailRaceVC: UIViewController {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!    
    @IBOutlet weak var markdownView: MarkdownView!
    
    var raceInfo: Race?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    private func initUI() {        
        title = "竞赛情况"
        if let raceInfo = raceInfo {
            iconImageView.sd_setImage(with: URL(string: baseURL + raceInfo.imageURL), completed: nil)
            nameLabel.text = raceInfo.name
            timeLabel.text = raceInfo.time
            typeLabel.text = raceInfo.type
            markdownView.load(markdown: raceInfo.content)
        }
    }
}
