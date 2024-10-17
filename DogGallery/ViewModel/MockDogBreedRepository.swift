//
//  MockDogBreedRepository.swift
//  DogGalleryTests
//
//  Created by Sahil Kamboj on 17/10/24.
//

import Foundation

public class MockDogBreedRepository: DogBreedRepository {
	var result: Result<DogBreeds, APIError>?
	var imageResult: Result<DogBreedImages, APIError>?
	var fetchCalled = false
	
	override func fetchDogBreedList(completion: @escaping (Result<DogBreeds, APIError>) -> Void) {
		fetchCalled = true
		if let result = result {
			completion(result)
		}
	}
	
	override func fetchDogBreedImages(breed: String, imageNumber: String, completion: @escaping (Result<DogBreedImages, APIError>) -> Void) {
		if let result = imageResult {
			completion(result)
		}
	}
}
