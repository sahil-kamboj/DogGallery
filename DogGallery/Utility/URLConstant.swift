//
//  URLConstant.swift
//  DogGallery
//
//  Created by Sahil Kamboj on 26/06/24.
//

import Foundation

struct AppURL {
	
	static let baseURL = "https://dog.ceo/api"
	
	static var getAllBreeds = "\(baseURL)/breeds/list/all"
	
	static func getBreedImages(_ breedName: String, image: String) -> String {
		return "\(baseURL)/breed/\(breedName)/images\(image)"
	}
}
