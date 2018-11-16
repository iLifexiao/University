//
//  FriendCell.swift
//  University
//
//  Created by 肖权 on 2018/11/16.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {

    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var introduceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupModel(_ userInfo: UserInfo) {
        headImageView.sd_setImage(with: URL(string: baseURL + userInfo.profilephoto), completed: nil)
        nameLabel.text = userInfo.nickname
        introduceLabel.text = userInfo.introduce
        if userInfo.sex == "男" {
            sexLabel.text = "♂"
            sexLabel.textColor = XQColor(r: 0, g: 206, b: 209)
        } else {
            sexLabel.text = "♀"
            sexLabel.textColor = XQColor(r: 255, g: 192, b: 203)
        }
    }
    
    override func prepareForReuse() {
        headImageView.image = nil
        nameLabel.text = nil
        introduceLabel.text = nil
        sexLabel.text = nil
    }    
}
