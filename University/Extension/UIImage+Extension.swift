//
//  UIImage+Extension.swift
//  University
//
//  Created by 肖权 on 2018/11/21.
//  Copyright © 2018 肖权. All rights reserved.
//

import Foundation

extension UIImage {
    open class func fromURL(_ url: String) -> UIImage? {
        if let imgURL = URL(string: url) {
            let imgData = try? Data(contentsOf: imgURL)
            guard imgData != nil else {
                return nil
            }
            return UIImage(data: imgData!)
        }
        return nil
    }
}
