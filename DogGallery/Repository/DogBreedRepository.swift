//
//  DogBreedRepository.swift
//  DogGallery
//
//  Created by Sahil Kamboj on 26/06/24.
//

import Foundation

public class DogBreedRepository {
	
	func fetchDogBreedList(completion: @escaping (Result<DogBreeds, APIError>) -> Void) {
		
		let getRequest = GetRequest<DogBreeds>(endpoint: AppURL.getAllBreeds)
		NetworkRequest.request(getRequest) { result in
			switch result {
				case .success(let success):
					completion(.success(success))
					break
				case .failure(let failure):
					completion(.failure(failure))
					break
			}
		}
	}
	
	func fetchDogBreedImages(breed: String, imageNumber: String, completion: @escaping (Result<DogBreedImages, APIError>) -> Void) {
		
		let endPoint = AppURL.getBreedImages(breed, image: imageNumber)
		let getRequest = GetRequest<DogBreedImages>(endpoint: endPoint)
		
		NetworkRequest.request(getRequest) { result in
			switch result {
			case .success(let success):
				completion(.success(success))
				
			case .failure(let failure):
				completion(.failure(failure))
			}
		}
	}
}
