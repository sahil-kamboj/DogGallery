//
//  ViewController.swift
//  DogGallery
//
//  Created by Sahil Kamboj on 25/06/24.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {

	@IBOutlet weak var dogListTableView: UITableView!
	let viewModel = AllBreedsViewModel()
	var dogBreedsList: [String: String] = [:]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUIandTableView()
		viewModel.getAllBreedsList()
		
		viewModel.dogBreedsListSuccess = { result in
			DispatchQueue.main.async {
				self.dogBreedsList = result
				self.dogListTableView.reloadData()
			}
		}
	}
	
	func setupUIandTableView() {
		
		self.title = "Dog Gallery"
		
		self.dogListTableView.delegate = self
		self.dogListTableView.dataSource = self
		
		self.dogListTableView.register(TableCell_DogBreed.nib, forCellReuseIdentifier: TableCell_DogBreed.identifier)
	}

	@IBAction func action_OpenFavourites(_ sender: UIBarButtonItem) {
		guard let VC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "FavouriteBreedViewController") as? FavouriteBreedViewController else { return }
		VC.viewModel = self.viewModel
		self.navigationController?.pushViewController(VC, animated: true)
	}
	
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dogBreedsList.keys.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: TableCell_DogBreed.identifier, for: indexPath) as? TableCell_DogBreed else { return UITableViewCell() }
		cell.selectionStyle = .none
		let breedName = Array(dogBreedsList.keys)[indexPath.row]
		cell.dogBreedImage.sd_setImage(with: URL(string: dogBreedsList[breedName] ?? ""), placeholderImage: UIImage(systemName: "dog.fill")?.withTintColor(.green))
		cell.dogBreedName.text = breedName.capitalized
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let VC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "DogImagesViewController") as? DogImagesViewController else { return }
		let breedName = Array(dogBreedsList.keys)[indexPath.row]
		VC.dogBreedName = breedName
		VC.viewModel = self.viewModel
		self.navigationController?.pushViewController(VC, animated: true)
	}
}

