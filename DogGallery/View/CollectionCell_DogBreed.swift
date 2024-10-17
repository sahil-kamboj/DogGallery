//
//  CollectionCell_DogBreed.swift
//  DogGallery
//
//  Created by Sahil Kamboj on 16/10/24.
//

import UIKit

class CollectionCell_DogBreed: UICollectionViewCell {
	
	class var identifier: String { return String(describing: self) }
	class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
	
	@IBOutlet weak var dogImage: UIImageView!
	@IBOutlet weak var dogBreedName: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
		
		dogImage.layer.cornerRadius = 10.0
		dogImage.layer.masksToBounds = true
    }
}
