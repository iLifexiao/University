//
//  LessonGradeCell.swift
//  University
//
//  Created by 肖权 on 2018/11/13.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class LessonGradeCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupModel(_ lessonGrade: LessonGrade) {
        nameLabel.text = lessonGrade.name
        typeLabel.text = lessonGrade.type
        creditLabel.text = String(lessonGrade.credit)
        // 不及格采用红色显示
        let grade = lessonGrade.grade
        if grade < 60 {
            gradeLabel.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        } else {
            gradeLabel.textColor = #colorLiteral(red: 0, green: 0.5829241371, blue: 0.2791121072, alpha: 1)
        }
        gradeLabel.text = String(grade)
    }
    
    override func prepareForReuse() {
        nameLabel.text = nil
        typeLabel.text = nil
        creditLabel.text = nil
        gradeLabel.text = nil
    }    
}
