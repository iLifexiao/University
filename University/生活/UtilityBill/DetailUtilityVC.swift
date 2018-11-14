//
//  DetailUtilityVC.swift
//  University
//
//  Created by 肖权 on 2018/11/14.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class DetailUtilityVC: UIViewController {
    
    
    @IBOutlet weak var siteLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var electricityPriceLabel: UILabel!
    @IBOutlet weak var coldWaterPriceLabel: UILabel!
    @IBOutlet weak var hotWaterLabel: UILabel!
    
    var bill: UtilityBill?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    private func initUI() {
        title = "账单详细"
        if let bill = bill {
            siteLabel.text = "宿舍_" + bill.site
            timeLabel.text = bill.time
            electricityPriceLabel.text = String(bill.electricityPrice)
            coldWaterPriceLabel.text = String(bill.waterPrice)
            hotWaterLabel.text = String(bill.hotWaterPrice ?? 0)
        }
    }


}
