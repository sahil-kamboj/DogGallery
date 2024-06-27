//
//  TableCell_DogBreed.swift
//  DogGallery
//
//  Created by Sahil Kamboj on 26/06/24.
//

import UIKit

class TableCell_DogBreed: UITableViewCell {
	
	class var identifier: String { return String(describing: self) }
	class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
	
	@IBOutlet weak var dogBreedImage: UIImageView!
	@IBOutlet weak var dogBreedName: UILabel!
	

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		dogBreedImage.layer.cornerRadius = 10.0
		dogBreedImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
