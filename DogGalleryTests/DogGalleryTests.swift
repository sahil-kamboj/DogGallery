//
//  DogGalleryTests.swift
//  DogGalleryTests
//
//  Created by Sahil Kamboj on 08/10/24.
//

import XCTest
@testable import DogGallery

final class DogGalleryTests: XCTestCase {
	
	var viewModel: AllBreedsViewModel!
	var mockService: MockDogBreedRepository!
	
	override func setUp() {
		super.setUp()
		mockService = MockDogBreedRepository()
		viewModel = AllBreedsViewModel()
		viewModel.service = mockService
	}
	
	override func tearDown() {
		viewModel = nil
		mockService = nil
		super.tearDown()
	}
	
	func testGetAllBreedsList_Success() {
//		let expectedResponse = ["hound": ["afghan", "basset"], "retriever": ["golden"]]
//		mockService.result = .success(DogBreeds(message: expectedResponse, status: ""))
		
//		let expectation = self.expectation(description: "BreedsListSuccess")
		
		let mockBreeds: [String: [String]] = ["Husky": ["Siberian"], "Retriever": ["Golden"]]
		mockService.result = .success(DogBreeds(message: mockBreeds, status: ""))
		
		viewModel.dogBreedsListSuccess = {
//			XCTAssertEqual(self.viewModel.dogBreedsList.count, 3)
//			XCTAssertEqual(self.viewModel.dogBreedsList["afghan hound"], "")
//			XCTAssertEqual(self.viewModel.dogBreedsList["basset hound"], "")
//			XCTAssertEqual(self.viewModel.dogBreedsList["golden retriever"], "")
//			expectation.fulfill()
		}
		
		viewModel.getAllBreedsList()
		
		XCTAssertEqual(viewModel.dogBreedsList.count, mockBreeds.count, "Dog breed list should have the correct count")
	}
	
	func testGetAllBreedsList_Failure() {
		let error = APIError.unknown(NSError(domain: "TestError", code: -1, userInfo: nil))
		mockService.result = .failure(error)
		
		viewModel.getAllBreedsList()
		
		// This tests whether the alert helper is called or not in case of failure
		XCTAssert(mockService.fetchCalled)
	}
	
	func testTransformDogBreedList() {
		let input = ["retriever": ["golden", "lab"], "poodle": []]
		
		viewModel.transformDogBreedList(input)
		print(viewModel.dogBreedsList.count)
		XCTAssertEqual(viewModel.dogBreedsList.count, 3)
		XCTAssertEqual(viewModel.dogBreedsList["golden retriever"], "")
		XCTAssertEqual(viewModel.dogBreedsList["lab retriever"], "")
		XCTAssertEqual(viewModel.dogBreedsList["poodle"], "")
	}
	
	func testCheckImagesForBreedsList() {
		let breeds = ["golden retriever": "", "poodle": ""]
		let expectedImageURL = "https://dog.ceo/api/img/retriever-golden.jpg"
		
		mockService.imageResult = .success(DogBreedImages(message: [expectedImageURL], status: ""))
		
		let expectation = self.expectation(description: "DogBreedsListSuccess")
		viewModel.dogBreedsListSuccess = {
			XCTAssertEqual(self.viewModel.dogBreedsList["golden retriever"], expectedImageURL)
			expectation.fulfill()
		}
		
		viewModel.checkImagesForBreedsList(breeds)
		waitForExpectations(timeout: 2.0, handler: nil)
	}
	
}
