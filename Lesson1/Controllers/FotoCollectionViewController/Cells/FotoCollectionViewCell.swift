//
//  FotoCollectionViewCell.swift
//  VK
//
//  Created by Pauwell on 14.04.2021.
//

import UIKit

class FotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var fotoImage: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeStackView: UIStackView!
    
    
    var isLiked = false
    
    var saveImage: UIImage?
    
    
    func clearCell() {
        fotoImage.image = nil
        saveImage = nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        clearCell()
        likeStackView.layer.cornerRadius = 5
    }

    override func prepareForReuse() {
        clearCell()
    }
    
    func configure(foto: UIImage) {
        fotoImage.image = foto
        saveImage = foto
    }
    
    @IBAction func pressLikeButton(_ sender: Any) {
        
        if !isLiked {
            likeLabel.text = "1"
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeButton.tintColor = UIColor.systemRed
        } else {
            likeLabel.text = "0"
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            
        }
    
        isLiked = !isLiked
    }
    
}
