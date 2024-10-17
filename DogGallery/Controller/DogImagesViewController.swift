//
//  DogImagesViewController.swift
//  DogGallery
//
//  Created by Sahil Kamboj on 26/06/24.
//

import UIKit

class DogImagesViewController: UIViewController {
	
	@IBOutlet weak var dogImagesCollectionView: UICollectionView!
	var viewModel = AllBreedsViewModel()
	var dogBreedName: String = ""
	var dogImages: [String] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupScreenAndCollectionView()
		viewModel.getAllImagesForDogBreed(viewModel.getDogBreedNameForImage(dogBreedName))
		
		viewModel.dogBreedImagesSuccess = { result in
			DispatchQueue.main.async {
				self.dogImages = result
				self.dogImagesCollectionView.reloadData()
			}
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.dogImagesCollectionView.reloadData()
	}
	
	func setupScreenAndCollectionView() {
		
		self.title = dogBreedName.capitalized
		self.dogImagesCollectionView.delegate = self
		self.dogImagesCollectionView.dataSource = self
		
		self.dogImagesCollectionView.register(CollectionCell_FavouriteBreed.nib, forCellWithReuseIdentifier: CollectionCell_FavouriteBreed.identifier)
	}
	
	
	@IBAction func action_BackButton(_ sender: UIBarButtonItem) {
		self.navigationController?.popViewController(animated: true)
	}
	
	func openFullImage(_ image: String) {
		guard let VC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "FullImageViewController") as? FullImageViewController else { return }
		VC.dogImageURL = image
		VC.dogBreedName = self.dogBreedName
		VC.viewModel = self.viewModel
		self.navigationController?.pushViewController(VC, animated: false)
	}
	
}

extension DogImagesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.dogImages.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell_FavouriteBreed.identifier, for: indexPath) as? CollectionCell_FavouriteBreed else { return UICollectionViewCell() }
		cell.dogImage.sd_setImage(with: URL(string: dogImages[indexPath.row]), placeholderImage: UIImage(systemName: "dog.fill"))
		cell.favouriteDogBtn.isFavourite(self.viewModel.favImageCheck(dogImages[indexPath.row]))
		cell.openImage = {
			self.openFullImage(self.dogImages[indexPath.row])
		}
		cell.toggleFavouriteDog = {
			self.viewModel.checkFavouriteDog(self.dogBreedName, dogImage: self.dogImages[indexPath.row]) {
				self.dogImagesCollectionView.reloadData()
			}
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.frame.width * 0.48, height: collectionView.frame.width * 0.48)
	}
	
}
