//
//  ViewController.swift
//  DogGallery
//
//  Created by Sahil Kamboj on 25/06/24.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {

//	@IBOutlet weak var dogListTableView: UITableView!
	@IBOutlet weak var dogListCollectionView: UICollectionView!
	private let viewModel = AllBreedsViewModel()
//	var dogBreedsList: [String: String] = [:]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
		viewModel.getAllBreedsList()
		
		viewModel.dogBreedsListSuccess = {
			DispatchQueue.main.async {
//				self.dogListTableView.reloadData()
				self.dogListCollectionView.reloadData()
			}
		}
	}
	
	func setupUI() {
		
		self.title = "Dog Gallery"
		
		self.dogListCollectionView.delegate = self
		self.dogListCollectionView.dataSource = self
		
		self.dogListCollectionView.register(CollectionCell_DogBreed.nib, forCellWithReuseIdentifier: CollectionCell_DogBreed.identifier)
	}

	@IBAction func action_OpenFavourites(_ sender: UIBarButtonItem) {
		guard let VC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "FavouriteBreedViewController") as? FavouriteBreedViewController else { return }
		VC.viewModel = self.viewModel
		self.navigationController?.pushViewController(VC, animated: true)
	}
	
}
/*
extension ViewController: UITableViewDelegate, UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.dogBreedsList.keys.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: TableCell_DogBreed.identifier, for: indexPath) as? TableCell_DogBreed else { return UITableViewCell() }
		cell.selectionStyle = .none
		let breedName = Array(viewModel.dogBreedsList.keys)[indexPath.row]
		cell.dogBreedImage.sd_setImage(with: URL(string: viewModel.dogBreedsList[breedName] ?? ""), placeholderImage: UIImage(systemName: "dog.fill")?.withTintColor(.gray))
		cell.dogBreedName.text = breedName.capitalized
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let VC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "DogImagesViewController") as? DogImagesViewController else { return }
		let breedName = Array(viewModel.dogBreedsList.keys)[indexPath.row]
		VC.dogBreedName = breedName
		VC.viewModel = self.viewModel
		self.navigationController?.pushViewController(VC, animated: true)
	}
}*/

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewModel.dogBreedsList.keys.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell_DogBreed.identifier, for: indexPath) as? CollectionCell_DogBreed else { return UICollectionViewCell() }
		let breedName = Array(viewModel.dogBreedsList.keys.sorted())[indexPath.row]
		cell.dogImage.sd_setImage(with: URL(string: viewModel.dogBreedsList[breedName] ?? ""), placeholderImage: UIImage(systemName: "dog.fill")?.withTintColor(.gray))
		cell.dogBreedName.text = breedName.capitalized
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.frame.width * 0.48, height: collectionView.frame.width * 0.48)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let VC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "DogImagesViewController") as? DogImagesViewController else { return }
		let breedName = Array(viewModel.dogBreedsList.keys.sorted())[indexPath.row]
		VC.dogBreedName = breedName
		VC.viewModel = self.viewModel
		self.navigationController?.pushViewController(VC, animated: true)
	}
}
