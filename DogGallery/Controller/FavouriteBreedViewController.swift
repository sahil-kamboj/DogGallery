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
//	var dogBreeds: [String: [String]] = [:]
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.title = "Favourite Pictures"
		self.setupScreenAndCollectionView()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		getDogBreedList()
	}
	
	func setupScreenAndCollectionView() {
		self.favouriteCollectionView.delegate = self
		self.favouriteCollectionView.dataSource = self
		
		self.favouriteCollectionView.register(CollectionCell_FavouriteBreed.nib, forCellWithReuseIdentifier: CollectionCell_FavouriteBreed.identifier)
		self.favouriteCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
		
		getDogBreedList()
	}
	
	func getDogBreedList() {
		self.viewModel.favouriteDogList = [:]
		for dog in self.viewModel.favouriteDogImages {
			if let breedName = dog.dogBreedName, let dogImage = dog.dogImageURL {
				if self.viewModel.favouriteDogList.keys.contains(breedName) {
					self.viewModel.favouriteDogList[breedName]?.append(dogImage)
				} else {
					self.viewModel.favouriteDogList[breedName] = [dogImage]
				}
			}
		}
		self.favouriteCollectionView.reloadData()
	}
    
	@IBAction func action_BackButton(_ sender: UIBarButtonItem) {
		self.navigationController?.popViewController(animated: true)
	}
	
	func openFullImage(_ name: String, image: String) {
		guard let VC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "FullImageViewController") as? FullImageViewController else { return }
		VC.dogImageURL = image
		VC.dogBreedName = name
		VC.viewModel = self.viewModel
		self.navigationController?.pushViewController(VC, animated: false)
	}
}

extension FavouriteBreedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return self.viewModel.favouriteDogList.keys.count
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		if kind == UICollectionView.elementKindSectionHeader {
			let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
			headerView.backgroundColor = .clear
			for subview in headerView.subviews {
				subview.removeFromSuperview()
			}
			let label = UILabel(frame: headerView.bounds)
			label.text = Array(self.viewModel.favouriteDogList.keys.sorted())[indexPath.section].capitalized
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
		return self.viewModel.favouriteDogList[Array(self.viewModel.favouriteDogList.keys.sorted())[section]]?.count ?? 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell_FavouriteBreed.identifier, for: indexPath) as? CollectionCell_FavouriteBreed else { return UICollectionViewCell() }
		let dogBreedURL = self.viewModel.favouriteDogList[Array(self.viewModel.favouriteDogList.keys.sorted())[indexPath.section]]?[indexPath.row]
		cell.dogImage.sd_setImage(with: URL(string: dogBreedURL ?? ""), placeholderImage: UIImage(systemName: "dog.fill"))
		cell.favouriteDogBtn.isFavourite(true)
		cell.openImage = {
			self.openFullImage(Array(self.viewModel.favouriteDogList.keys.sorted())[indexPath.section], image: dogBreedURL ?? "")
		}
		cell.toggleFavouriteDog = {
			self.viewModel.checkFavouriteDog(Array(self.viewModel.favouriteDogList.keys.sorted())[indexPath.section], dogImage: dogBreedURL ?? "") {
				self.getDogBreedList()
			}
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.frame.width * 0.48, height: collectionView.frame.width * 0.48)
	}
}
