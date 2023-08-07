//
//  MainTabBarController.swift
//  PhotoLibrary
//
//  Created by Borys Klykavka on 30.07.2023.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        
        let photosVC = PhotosCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        // viewControllers an array of viewControllers displayed by tab bar inference
        viewControllers = [
            generateNavigationController(rootViewController: photosVC, title: "Photos", image: UIImage(systemName: "photo")!),
            generateNavigationController(rootViewController: ViewController(), title: "Favourites", image: UIImage(systemName: "photo.on.rectangle.angled")!)]
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title

        return navigationVC
    }
    
}
