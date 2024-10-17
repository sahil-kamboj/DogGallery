//
//  FullImageViewController.swift
//  DogGallery
//
//  Created by Sahil Kamboj on 16/10/24.
//

import UIKit

class FullImageViewController: UIViewController {
	
	@IBOutlet weak var dogImage: UIImageView!
	@IBOutlet weak var favouriteBtn: UIButton!
	var viewModel = AllBreedsViewModel()
	var dogImageURL: String = ""
	var dogBreedName: String = ""
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationController?.navigationBar.isHidden = true
		dogImage.sd_setImage(with: URL(string: dogImageURL), placeholderImage: UIImage(systemName: "dog.fill"))
		self.favouriteBtn.isFavourite(self.viewModel.favImageCheck(self.dogImageURL))
    }
    
	@IBAction func action_CloseImage(_ sender: UIButton) {
		self.navigationController?.popViewController(animated: false)
	}
	
	@IBAction func action_favouriteBtn(_ sender: UIButton) {
		self.viewModel.checkFavouriteDog(self.dogBreedName, dogImage: self.dogImageURL) {
			self.favouriteBtn.isFavourite(self.viewModel.favImageCheck(self.dogImageURL))
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		self.navigationController?.navigationBar.isHidden = false
	}
	
}
