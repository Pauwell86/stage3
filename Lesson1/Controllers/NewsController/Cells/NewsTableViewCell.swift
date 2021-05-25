//
//  NewsTableViewCell.swift
//  VK
//
//  Created by Pauwell on 26.04.2021.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleNewsLabel: UILabel!
    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var repostButton: UIButton!
    @IBOutlet weak var repostLabel: UILabel!   
    @IBOutlet weak var viewButtom: UIButton!
    @IBOutlet weak var viewLabel: UILabel!
    
    var saveNews: News?
    
    func clearCell() {
        titleNewsLabel.text = nil
        imageNews.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clearCell()
    }

    override func prepareForReuse() {
        clearCell()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWithNews(news: News) {
        titleNewsLabel.text = news.newsTtitle
      //  titleNewsLabel.textColor = UIColor.systemBlue
        imageNews.image = news.newsImage
        saveNews = news
    }
    
}
