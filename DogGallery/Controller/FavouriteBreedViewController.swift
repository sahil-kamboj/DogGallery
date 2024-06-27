//
//  FavouriteBreedViewController.swift
//  DogGallery
//
//  Created by Sahil Kamboj on 26/06/24.
//

import UIKit

class FavouriteBreedViewController: UIViewController {
	
	@IBOutlet weak var favouriteCollectionView: UICollectionView!
	
	var viewModel = AllBreedsViewModel()
	var dogBreeds: [String: [String]] = [:]
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.title = "Favourite Pictures"
		self.setupScreenAndCollectionView()
    }
	
	func setupScreenAndCollectionView() {
		self.favouriteCollectionView.delegate = self
		self.favouriteCollectionView.dataSource = self
		
		self.favouriteCollectionView.register(CollectionCell_FavouriteBreed.nib, forCellWithReuseIdentifier: CollectionCell_FavouriteBreed.identifier)
		self.favouriteCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
		
		getDogBreedList()
	}
	
	func getDogBreedList() {
		
		for dog in self.viewModel.favouriteDogImages {
			if let breedName = dog.dogBreedName, let dogImage = dog.dogImageURL {
				if dogBreeds.keys.contains(breedName) {
					dogBreeds[breedName]?.append(dogImage)
				}
				else {
					dogBreeds[breedName] = [dogImage]
				}
			}
		}
		self.favouriteCollectionView.reloadData()
	}
    
	@IBAction func action_BackButton(_ sender: UIBarButtonItem) {
		self.navigationController?.popViewController(animated: true)
	}
	
	func checkFavouriteDog(_ input: String) {
		if viewModel.favouriteDogImages.contains(where: { $0.dogImageURL == input }) {
			self.viewModel.favouriteDogImages.removeAll(where: { $0.dogImageURL == input })
		}
		self.favouriteCollectionView.reloadData()
		print("Favourite Dogs: ", self.viewModel.favouriteDogImages)
	}
    
}

extension FavouriteBreedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return dogBreeds.keys.count
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		if kind == UICollectionView.elementKindSectionHeader {
			let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
			headerView.backgroundColor = .clear
			
				// Remove any existing subviews
			for subview in headerView.subviews {
				subview.removeFromSuperview()
			}
			
				// Add a label to the header view
			let label = UILabel(frame: headerView.bounds)
			label.text = Array(dogBreeds.keys)[indexPath.section]
			label.textAlignment = .center
			
			label.font = UIFont.boldSystemFont(ofSize: 16)
			headerView.addSubview(label)
			
			return headerView
		}
		return UICollectionReusableView()
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return CGSize(width: collectionView.frame.width, height: 50)
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return dogBreeds[Array(dogBreeds.keys)[section]]?.count ?? 0//self.viewModel.favouriteDogImages.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell_FavouriteBreed.identifier, for: indexPath) as? CollectionCell_FavouriteBreed else { return UICollectionViewCell() }
		let dogBreedURL = dogBreeds[Array(dogBreeds.keys)[indexPath.section]]?[indexPath.row]//self.viewModel.favouriteDogImages[indexPath.row].dogImageURL
		cell.dogImage.sd_setImage(with: URL(string: dogBreedURL ?? ""), placeholderImage: UIImage(systemName: "dog.fill"))
		cell.favouriteDogBtn.isFavourite(true)
		cell.toggleFavouriteDog = {
			self.checkFavouriteDog(dogBreedURL ?? "")
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.frame.width * 0.48, height: collectionView.frame.width * 0.48)
	}
}
