//
//  FotoCollectionViewController.swift
//  VK
//
//  Created by Pauwell on 14.04.2021.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "Cell"

class FotoCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var user: UserJSON?
    var fotosArray = [UIImage]()
    var photosFriends = VKService()
    let countCells = 2
    let FotoCollectionViewCellReuse = "FotoCollectionViewCell"


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(UINib(nibName: "FotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: FotoCollectionViewCellReuse)
        
        guard let _ = user,
              let userID = user?.id
        else { return }
        
        DataStorage.shared.userID = userID
        
        photosFriends.getFriendsFotos { [weak self] photosJSON in
            
            let albumArray = photosJSON
            albumArray.forEach {
                $0.sizes.forEach {
                    if $0.type.rawValue == "z" {
                        if let url = URL(string: $0.url) {
                           let data = try? Data(contentsOf: url)
                           let image = UIImage(data: data!)
                           self?.fotosArray.append(image!)
                    }
                }
            }
            
            DataStorage.shared.friedPhotos = self!.fotosArray
            
            self!.collectionView.reloadData()
            }
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

      override  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataStorage.shared.friedPhotos.count
    }

      override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FotoCollectionViewCellReuse, for: indexPath) as? FotoCollectionViewCell else {return UICollectionViewCell()}
    
        cell.configure(foto: DataStorage.shared.friedPhotos[indexPath.item])
    
        return cell
    }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let frameCV = collectionView.frame
            let widthCell = frameCV.width / CGFloat(countCells)
            let heigthCell = widthCell + 20
            return CGSize(width: widthCell , height: heigthCell)
    }



}
