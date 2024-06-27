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
	var toggleFavouriteDog: (() -> Void)?
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		dogImage.layer.cornerRadius = 10.0
		dogImage.layer.masksToBounds = true
    }

	@IBAction func action_FavouriteDog(_ sender: UIButton) {
		self.toggleFavouriteDog?()
	}
}
