//
//  AddressListCell.swift
//  University
//
//  Created by 肖权 on 2018/11/13.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class AddressListCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupModel(_ address: AddressList) {
        nameLabel.text = address.name
        phoneLabel.text = address.phone
        typeLabel.text = address.type
    }
    
    override func prepareForReuse() {
        nameLabel.text = nil
        phoneLabel.text = nil
        typeLabel.text = nil
    }    
}
