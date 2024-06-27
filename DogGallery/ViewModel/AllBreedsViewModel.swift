//
//  AllBreedsViewModel.swift
//  DogGallery
//
//  Created by Sahil Kamboj on 26/06/24.
//

import Foundation

class AllBreedsViewModel {
	
	let repository = DogBreedRepository()
	var favouriteDogImages: [FavouriteDog] = []
	var dogBreedsListSuccess: (([String: String]) -> Void)?
	var dogBreedImagesSuccess: (([String]) -> Void)?
	
	func getAllBreedsList() {
		
		repository.fetchDogBreedList { result in
			switch result {
				case .success(let success):
					print("Get ALL Breeds List -> Success", success)
					self.transformDogBreedList(success.message)
					break
					
				case .failure(let failure):
					print("Get ALL Breeds List -> Error", failure)
					break
			}
		}
	}
	
	func transformDogBreedList(_ input: [String: [String]]) {
		
		var allValues: [String: String] = [:]

		for (key, values) in input {
			if values.count > 0 {
				for value in values {
					allValues["\(value) \(key)"] = ""
				}
			}
			else {
				allValues["\(key)"] = ""
			}
		}
		self.checkImagesForBreedsList(allValues)
		print("All Breeds : ", allValues)
	}
	
	func checkImagesForBreedsList(_ breeds: [String: String]) {
		
		var dogBreeds = breeds
		
		let dispatchGroup = DispatchGroup()
		
		for (key, values) in breeds {
			
			dispatchGroup.enter()
			
			var breed = self.getDogBreedNameForImage(key)
			self.getDogBreedImage(breedName: breed, allImages: false) { result in
				
				switch result {
					case .success(let success):
						dogBreeds[key] = success.message[0]
						dispatchGroup.leave()
						
					case .failure(let failure):
						dispatchGroup.leave()
				}
			}
		}
		dispatchGroup.notify(queue: .main) {
			self.dogBreedsListSuccess?(dogBreeds)
		}
	}
	
	func getDogBreedNameForImage(_ input: String) -> String {
		var output = String()
		if input.contains(" ") {
			let item = input.components(separatedBy: " ")
			output = "\(item[1])/\(item[0])"
		}
		else {
			output = "\(input)"
		}
		return output
	}
	
	func getDogBreedImage(breedName: String, allImages:Bool, completion: @escaping (Result<DogBreedImages,APIError>) -> Void) {
		var imageNumber = allImages ? "" : "/random/1"
		
		repository.fetchDogBreedImages(breed: breedName, imageNumber: imageNumber) { result in
			switch result {
				case .success(let success):
					print("Get Breeds Images -> Success", success)
					completion(.success(success))
					break
					
				case .failure(let failure):
					print("Get Breeds Images -> Error", failure)
					completion(.failure(failure))
					break
			}
		}
	}
	
	func getAllImagesForDogBreed(_ breedName: String) {
		
		self.getDogBreedImage(breedName: breedName, allImages: true) { result in
			switch result {
				case .success(let success):
					self.dogBreedImagesSuccess?(success.message)
				case .failure(let failure):
					AlertHelper.infoAlert("Error!", message: failure.localizedDescription)
					break
			}
		}
	}
}
