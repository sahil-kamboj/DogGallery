//
//  CollectionCell_FavouriteBreed.swift
//  DogGallery
//
//  Created by Sahil Kamboj on 26/06/24.
//

import UIKit

class CollectionCell_FavouriteBreed: UICollectionViewCell {

	class var identifier: String { return String(describing: self) }
	class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
	
	@IBOutlet weak var dogImage: UIImageView!
	@IBOutlet weak var favouriteDogBtn: UIButton!
	var openImage: (() -> Void)?
	var toggleFavouriteDog: (() -> Void)?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		setupGestureRecognizers()
		dogImage.layer.cornerRadius = 10.0
		dogImage.layer.masksToBounds = true
	}
	
	private func setupGestureRecognizers() {
		// Single tap gesture
		let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
		singleTapGesture.numberOfTapsRequired = 1
		
		// Double tap gesture
		let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
		doubleTapGesture.numberOfTapsRequired = 2
		
		// Ensure the single tap waits for double tap to fail
		singleTapGesture.require(toFail: doubleTapGesture)
		
		// Add gestures to the contentView (the main view of the cell)
		contentView.addGestureRecognizer(singleTapGesture)
		contentView.addGestureRecognizer(doubleTapGesture)
	}
	
	@objc private func handleSingleTap() {
		print("Single tap detected")
		self.openImage?()
	}
	
	@objc private func handleDoubleTap() {
		self.toggleFavouriteDog?()
	}

	@IBAction func action_FavouriteDog(_ sender: UIButton) {
		self.toggleFavouriteDog?()
	}
}
