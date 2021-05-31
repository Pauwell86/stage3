//
//  MyTableViewCell.swift
//  VK
//
//  Created by Pauwell on 13.04.2021.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    var saveUser: User?
    var saveGroup: Group?
    
    func clearCell() {
        myImage.image = nil
        nameLabel.text = nil
        ageLabel.text = nil
        saveUser = nil
        saveGroup = nil
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


    }
    
   override func layoutSubviews() {
        super.layoutSubviews()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.blue.cgColor, UIColor.white.cgColor]
        gradientLayer.locations = [0, 0.6]
        gradientLayer.startPoint = CGPoint.zero
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = contentView.frame

        cellView.layer.addSublayer(gradientLayer)
    }
    
    
    func configureWithUser(user: User) {
        nameLabel.text = user.name
        
        if let age = user.age {
            ageLabel.text = String(age) + " лет"
        }
        
        if let image = user.avatar {
            myImage.image = image
            myImage.layer.cornerRadius = 50

        }
        
        myView.layer.cornerRadius = 50
        myView.layer.shadowColor = UIColor.white.cgColor
        myView.layer.shadowRadius = 20
        myView.layer.shadowOpacity = 0.9

        saveUser = user
    
        

    }
    
    func configureWithGroup(group: Group) {
        nameLabel.text = group.name
        
        if group.discription != nil {
            ageLabel.text = group.discription
        }
        
        if let image = group.groupImage {
            myImage.image = image
            myImage.layer.cornerRadius = 80
            
        }
        
        myView.layer.cornerRadius = 80
        myView.layer.shadowColor = UIColor.systemRed.cgColor
        myView.layer.shadowRadius = 15
        myView.layer.shadowOpacity = 0.7
        
        saveGroup = group
                
    }
    

//    @IBAction func pressButton(_ sender: Any) {
    
func animeAvatar() {
    let anime = CASpringAnimation(keyPath: "transform.scale")
        anime.fromValue = 0.8
        anime.toValue = 1
        anime.stiffness = 300
        anime.mass = 5
    anime.duration = 1
    
        myImage.layer.add(anime, forKey: nil)
        myView.layer.add(anime, forKey: nil)
  
    }
    
}
