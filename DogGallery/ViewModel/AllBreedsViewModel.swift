//
//  AllBreedsViewModel.swift
//  DogGallery
//
//  Created by Sahil Kamboj on 26/06/24.
//

import Foundation

class AllBreedsViewModel {
	
	var service = DogBreedRepository() // DogBreedService()
	var favouriteDogImages: [FavouriteDog] = []
	var favouriteDogList: [String: [String]] = [:]
	var dogBreedsList: [String: String] = [:]
	
	var selectedDogBreedName: String = ""
	
	var dogBreedsListSuccess: (() -> Void)?
	var dogBreedImagesSuccess: (([String]) -> Void)?
	
	// Get All Dog Breed list
	func getAllBreedsList() {
		service.fetchDogBreedList { [weak self] result in
			switch result {
			case .success(let success):
				print("Get ALL Breeds List -> Success: ", success)
				self?.transformDogBreedList(success.message)
				break
				
			case .failure(let failure):
				print("Get ALL Breeds List -> Failure: ", failure)
				AlertHelper.infoAlert("Error!", message: failure.localizedDescription) {
					self?.getAllBreedsList()
				}
				break
			}
		}
	}
	
	// Transform the response list into Linear breed list
	func transformDogBreedList(_ input: [String: [String]]) {
		var allValues: [String: String] = [:]
		for (key, values) in input {
			if values.count > 0 {
				for value in values {
					allValues["\(value) \(key)"] = ""
				}
			} else {
				allValues["\(key)"] = ""
			}
		}
		self.dogBreedsList = allValues
		self.checkImagesForBreedsList(allValues)
		print("All Breeds: ", allValues)
	}
	
	// Fetch image for the Linear breed list
	func checkImagesForBreedsList(_ breeds: [String: String]) {
		var dogBreeds = breeds
		let dispatchGroup = DispatchGroup()
		for (key, _) in breeds {
			dispatchGroup.enter()
			let breed = self.getDogBreedNameForImage(key)
			self.getDogBreedImage(breedName: breed, allImages: false) { result in
				switch result {
				case .success(let success):
					dogBreeds[key] = success.message[0]
					dispatchGroup.leave()
					
				case .failure(let failure):
					print("Get Dog Breed Image -> Failure : \(failure.localizedDescription)")
					dispatchGroup.leave()
				}
			}
		}
		dispatchGroup.notify(queue: .main) {
			self.dogBreedsList = dogBreeds
			self.dogBreedsListSuccess?()
		}
	}
	
	// Convert dog breed name for the image fetch request
	func getDogBreedNameForImage(_ input: String) -> String {
		var output = String()
		if input.contains(" ") {
			let item = input.components(separatedBy: " ")
			output = "\(item[1])/\(item[0])"
		} else {
			output = "\(input)"
		}
		return output
	}
	
	// Get image for dog breed, can be 1 or all with Bool check
	func getDogBreedImage(breedName: String, allImages: Bool, completion: @escaping (Result<DogBreedImages, APIError>) -> Void) {
		let imageNumber = allImages ? "" : "/random/1"
		service.fetchDogBreedImages(breed: breedName, imageNumber: imageNumber) { result in
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
	
	// Fetch all image for a dog breed
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
	
	func checkFavouriteDog(_ dogName: String, dogImage: String, completion: (() -> Void)? ) {
		print("dog Image: ", dogImage)
		if self.favouriteDogImages.contains(where: { $0.dogImageURL == dogImage }) {
			self.favouriteDogImages.removeAll(where: { $0.dogImageURL == dogImage })
		} else {
			self.favouriteDogImages.append(FavouriteDog(dogBreedName: dogName, dogImageURL: dogImage))
		}
		print("Favourite Dogs: ", self.favouriteDogImages)
		completion?()
	}
	
	func favImageCheck(_ dogImage: String) -> Bool {
		if self.favouriteDogImages.contains(where: { $0.dogImageURL == dogImage }) {
			return true
		} else {
			return false
		}
	}
}
