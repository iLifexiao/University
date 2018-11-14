//
//  UtilityBillVC.swift
//  University
//
//  Created by 肖权 on 2018/11/14.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class UtilityBillVC: UIViewController {

    @IBOutlet weak var siteTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    
    var bills: [UtilityBill] = []
    var param: [String: String] = [:]
    var finshed: Int {
        set {
            guard bills.count != 0 else {
                view.makeToast("查询失败,检查输入是否正确", position: .top)
                return
            }
            let bill = bills.first
            let detailVC = DetailUtilityVC()
            detailVC.bill = bill
            navigationController?.pushViewController(detailVC, animated: true)
        }
        get {
            return bills.count
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "水电费查询"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    
    private func getUtilityBill() {
        // 对于带参数的请求方式，采用参数，不能直接写在URL中
        // 同时注意参数的位置
        Alamofire.request(baseURL + "/api/v1/utilitybill/search", parameters: param, headers: headers).responseJSON { [weak self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self?.bills.removeAll()
                for (_, subJson):(String, JSON) in json {
                    self?.bills.append(UtilityBill(jsonData: subJson))
                }
                self?.finshed = 1
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func searchUtilityBill(_ sender: UIButton) {
        let site = siteTextField.text
        let time = timeTextField.text
        
        guard site != "" else {
            view.makeToast("宿舍不能为空", position: .top)
            return
        }
        
        guard time != "" else {
            view.makeToast("时间不能为空", position: .top)
            return
        }
        
        // 生成参数
        param = ["term": site!, "year": time!]
        getUtilityBill()
    }
    
}
