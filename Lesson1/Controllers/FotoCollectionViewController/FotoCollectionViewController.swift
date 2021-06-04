//
//  FotoCollectionViewController.swift
//  VK
//
//  Created by Pauwell on 14.04.2021.
//

import UIKit

private let reuseIdentifier = "Cell"

class FotoCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var user: User?
    let countCells = 2
    let FotoCollectionViewCellReuse = "FotoCollectionViewCell"
    var fotosArray = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(UINib(nibName: "FotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: FotoCollectionViewCellReuse)
        
        guard let _ = user,
              let array = user?.fotoArray
        else { return }
        
        fotosArray = array
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

      override  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fotosArray.count
    }

      override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FotoCollectionViewCellReuse, for: indexPath) as? FotoCollectionViewCell else {return UICollectionViewCell()}
    
        cell.configure(foto: fotosArray[indexPath.item])
    
        return cell
    }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let frameCV = collectionView.frame
            let widthCell = frameCV.width / CGFloat(countCells)
            let heigthCell = widthCell + 50
            return CGSize(width: widthCell, height: heigthCell)
    }

}

//extension FotoCollectionViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        return CGSize(width: 100, height: 100)
//    }
//}
