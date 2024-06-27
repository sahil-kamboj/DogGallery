//
//  UIButton+Extension.swift
//  DogGallery
//
//  Created by Sahil Kamboj on 26/06/24.
//

import Foundation
import UIKit

extension UIButton {
	
	func isFavourite(_ input: Bool) {
		if input {
			self.setImage(UIImage(systemName: "heart.fill"), for: .normal)
		}
		else {
			self.setImage(UIImage(systemName: "heart"), for: .normal)
		}
	}
}
