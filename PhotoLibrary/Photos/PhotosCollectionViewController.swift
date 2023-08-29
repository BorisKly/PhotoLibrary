//
//  PhotosCollectionViewController.swift
//  PhotoLibrary
//
//  Created by Borys Klykavka on 29.08.2023.
//

import UIKit

class PhotosCollectionViewController: UICollectionViewController {
    
    private var myPhotos = [UIImage]()
    
    private let itemsPerRow: CGFloat = 2
    
    private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
 
    private var selectedImages = [UIImage]()

    private var numberOfSelectedPhotos: Int {
        return collectionView.indexPathsForSelectedItems?.count ?? 0
    }
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped))
    }()
    
    private lazy var  photoActionBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(photoBarButtonTapped))
    }()
    
    private lazy var trashBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashBarButtonTapped))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = Colors.backgroundBase
        
        updateNavButtonsState()
        loadPhotosFromFileManager()
        setupNavigationBar()
        setupCollectionView()
    }
    
    private func updateNavButtonsState() {
        addBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
        trashBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
    }
    
    func refresh() {
        print(selectedImages)
        self.selectedImages.removeAll()
        self.collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
        updateNavButtonsState()
    }
    
    private func loadPhotosFromFileManager() {
        
        let fileManager = FileManager.default
        
        if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            do {
                let fileURLs = try fileManager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
                print("!!!list of files in \(fileURLs)")
                for fileURL in fileURLs {
                    print("!!!!!!!!!\(fileURL)")
                    if let image = UIImage(contentsOfFile: fileURL.path) {
                        myPhotos.append(image)
                    }
                }
            }
            catch {
                print("error getting a list of files \(error)")
            }
        }
    }
  
    // MARK:- Setup UI Elements
        
        private func setupCollectionView() {
        collectionView.register(PhotosCell.self, forCellWithReuseIdentifier: PhotosCell.reuseId)
        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.allowsMultipleSelection = true
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "MY PHOTOS"
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        titleLabel.textColor = Colors.primaryColor
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        
        navigationItem.rightBarButtonItems = [photoActionBarButtonItem, addBarButtonItem, trashBarButtonItem]
    }
    
    
    // MARK: - NavigationItems Action

    @objc private func addBarButtonTapped(){
        print(#function)
    }
    
    @objc private func photoBarButtonTapped(){
        print(#function)
        let vc = CameraViewController()
        present(vc, animated: true)
    }
    
    @objc private func trashBarButtonTapped(){
        
        self.refresh()
        
    }
    
    // MARK: UICollectionViewDataSource and UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myPhotos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCell.reuseId, for: indexPath) as! PhotosCell
        cell.photoImageView.image = myPhotos[indexPath.item]
        cell.backgroundColor = .systemGreen
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateNavButtonsState()
        let cell = collectionView.cellForItem(at: indexPath) as! PhotosCell
        guard let image = cell.photoImageView.image else {
            return
        }
        
        selectedImages.append(image)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        updateNavButtonsState()
        let cell = collectionView.cellForItem(at: indexPath) as! PhotosCell
        guard let image = cell.photoImageView.image else {
            return
        }
        if let index = selectedImages.firstIndex(of: image) {
            selectedImages.remove(at: index)
        }
    }
    
}
// MARK: - UICollectionViewDelegateFlowLayout
//
extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    
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







