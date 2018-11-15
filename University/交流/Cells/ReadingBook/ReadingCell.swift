//
//  ReadingCell.swift
//  University
//
//  Created by 肖权 on 2018/10/26.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class ReadingCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var bookPagesLabel: UILabel!
    @IBOutlet weak var bookDetailLabel: UILabel!
    @IBOutlet weak var readCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    private var id: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
        
    func setupModel(_ book: Book) {
        id = String(book.id ?? 0)
        iconImageView.sd_setImage(with: URL(string: baseURL + book.imageURL), completed: nil)
        bookNameLabel.text = book.name
        authorLabel.text = book.author
        typeLabel.text = book.type
        bookPagesLabel.text = String(book.bookPages) + " 页"
        readCountLabel.text = String(book.readedCount ?? 0) + " 阅读"
        likeCountLabel.text = String(book.likeCount ?? 0) + " 喜欢"
        bookDetailLabel.text = book.introduce
    }
    
    override func prepareForReuse() {
        iconImageView.image = nil
        bookNameLabel.text = nil
        authorLabel.text = nil
        typeLabel.text = nil
        bookPagesLabel.text = nil
        readCountLabel.text = nil
        likeCountLabel.text = nil
        bookDetailLabel.text = nil
    }
}
