//
//  ErrorResponse.swift
//  DogGallery
//
//  Created by Sahil Kamboj on 26/06/24.
//

import Foundation

// MARK: - ErrorResponse
struct ErrorResponse: Codable {
	let status, message: String
	let code: Int
}
