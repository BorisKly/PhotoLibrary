//
//  ViewController.swift
//  PhotoLibrary
//
//  Created by Borys Klykavka on 30.07.2023.
//

import UIKit

class FavouritesCollectionViewController: UICollectionViewController {
    
   // public var photos = [String]()
        
    private let itemsPerRow: CGFloat = 2

    private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let directoryPath = documentsURL.path
        
        do {
            let fileNames = try fileManager.contentsOfDirectory(atPath: directoryPath)
           // self.photos = fileNames
            print("list of files in \(fileNames)")
        } catch {
            print("error getting a list of files \(error)")
        }
        
    }
    
    // MARK: - Setup UI Elements
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .systemYellow
       
        collectionView.register(FavouritesCell.self, forCellWithReuseIdentifier: FavouritesCell.reuseId)
        
        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
      
        collectionView.contentInsetAdjustmentBehavior = .automatic
      
        collectionView.allowsMultipleSelection = true
    }
    

    // MARK: - UICollectionViewDataSource, UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavouritesCell.reuseId, for: indexPath) as! FavouritesCell
//
//        let getPhoto = photos[indexPath.item]
//        cell.unsplashPhoto = unsplashedPhoto
        cell.backgroundColor = .systemRed
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //updateNavButtonsState()
//        let cell = collectionView.cellForItem(at: indexPath) as! FavouritesCell
//        guard let image = cell.photoImageView.image else {
//            return
//        }
//        selectedImages.append(image)
    }
    
//    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        updateNavButtonsState()
//        let cell = collectionView.cellForItem(at: indexPath) as! PhotosCell
//        guard let image = cell.photoImageView.image else {
//            return
//        }
//        if let index = selectedImages.firstIndex(of: image) {
//            selectedImages.remove(at: index)
//        }
//    }
}

// MARK: - UICollectionViewDelegateFlowLayout
//
extension FavouritesCollectionViewController: UICollectionViewDelegateFlowLayout {
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingSpace = sectionInserts.left * (itemsPerRow + 1)
        let availiableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availiableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        sectionInserts
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        sectionInserts.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        sectionInserts.left
    }
}



//}

