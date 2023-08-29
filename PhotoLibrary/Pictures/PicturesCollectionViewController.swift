//
//  PicturesCollectionViewController.swift
//  PhotoLibrary
//
//  Created by Borys Klykavka on 29.08.2023.
//


import UIKit
import CoreImage

class PicturesCollectionViewController: UICollectionViewController {
  
    var networkDataFetcher = NetworkDataFetcher()
   
    private var timer: Timer?
    
    private var pictures = [UnsplashPhoto]()
    
    private var selectedImages = [UIImage]()
    
    private let itemsPerRow: CGFloat = 2
   
    private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped))
    }()
    private lazy var actionBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionBarButtonTapped))
    }()
    
    private var numberOfSelectedPhotos: Int {
        return collectionView.indexPathsForSelectedItems?.count ?? 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = Colors.primaryColor
        
        updateNavButtonsState()
        setupNavigationBar()
        setupCollectionView()
        setupSearchBar()
    }
    
    private func updateNavButtonsState() {
        addBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
        actionBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
    }
    
    func refresh() {
        self.selectedImages.removeAll()
        self.collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
        updateNavButtonsState()
    }
    // MARK: - NavigationItems Action
    
    @objc private func addBarButtonTapped(){
        print(#function)
    }
    
    @objc private func actionBarButtonTapped(sender: UIBarButtonItem){
        print(#function)
        
        let shareController = UIActivityViewController(activityItems: selectedImages, applicationActivities: nil)
        shareController.completionWithItemsHandler = {
            _, bool, _, _ in
            if bool {
                self.refresh()
            }
        }
        
        shareController.popoverPresentationController?.barButtonItem = sender
        shareController.popoverPresentationController?.permittedArrowDirections = .any
        present(shareController, animated: true)
    }
    
    // MARK: - Setup UI Elements
    
    private func setupCollectionView() {
        collectionView.register(PicturesCell.self, forCellWithReuseIdentifier: PicturesCell.reuseId)
        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.allowsMultipleSelection = true
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "PICTURES"
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        titleLabel.textColor = Colors.backgroundBase
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        
        navigationItem.rightBarButtonItems = [addBarButtonItem, actionBarButtonItem]
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
    }

    // MARK: - UICollectionViewDataSource, UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PicturesCell.reuseId, for: indexPath) as! PicturesCell
       
        let unsplashedPhoto = pictures[indexPath.item]
        cell.unsplashPhoto = unsplashedPhoto
        cell.backgroundColor = .systemGreen
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateNavButtonsState()
        let cell = collectionView.cellForItem(at: indexPath) as! PicturesCell
        guard let image = cell.photoImageView.image else {
            return
        }
        selectedImages.append(image)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        updateNavButtonsState()
        let cell = collectionView.cellForItem(at: indexPath) as! PicturesCell
        guard let image = cell.photoImageView.image else {
            return
        }
        if let index = selectedImages.firstIndex(of: image) {
            selectedImages.remove(at: index)
        }
    }
}

// MARK: - UISearchBArDelegate

extension PicturesCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            self.networkDataFetcher.fetchImages(searchTerm: searchText) { [weak self] searchResults in
                guard let fetchedPhotos = searchResults else {return}
                self?.pictures = fetchedPhotos.results
                self?.collectionView.reloadData()
                self?.refresh()
            }
        })
    }
}
// MARK: - UICollectionViewDelegateFlowLayout

extension PicturesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = pictures[indexPath.item]
        let paddingSpace = sectionInserts.left * (itemsPerRow + 1)
        let availiableWidth = view.frame.width - paddingSpace
        let widthPerItem = availiableWidth / itemsPerRow
        let height = CGFloat(photo.height) * widthPerItem / CGFloat(photo.width)
        return CGSize(width: widthPerItem, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        sectionInserts.left
    }
}


