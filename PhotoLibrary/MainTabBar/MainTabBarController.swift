//
//  MainTabBarController.swift
//  PhotoLibrary
//
//  Created by Borys Klykavka on 30.07.2023.
//

import UIKit
import AVFoundation

class MainTabBarController: UITabBarController {
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        
        let picturesVC = PicturesCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let photosVC = PhotosCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let favouritesVC = FavouritesCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        viewControllers = [
            generateNavigationController(rootViewController: picturesVC, title: "Pictures", image: UIImage(systemName: "photo")!),
            
            generateNavigationController(rootViewController: photosVC, title: "Photos", image: UIImage(systemName: "photo.stack")!),
            
            generateNavigationController(rootViewController: favouritesVC, title: "Favourites", image: UIImage(systemName: "photo.on.rectangle.angled")!)
        ]
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title

        return navigationVC
    }
    
   
    
}
