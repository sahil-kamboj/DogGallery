//
//  AlertController.swift
//  DogGallery
//
//  Created by Sahil Kamboj on 26/06/24.
//

import Foundation
import UIKit

class AlertHelper {
	
	static func showAlert(title: String?, message: String?, completion: (() -> Void)? = nil) {
		if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
		   let sceneDelegate = windowScene.delegate as? SceneDelegate {
			
			if let rootViewController = sceneDelegate.window?.rootViewController {
				let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
				
				let okAction = UIAlertAction(title: "OK", style: .default) { _ in
					completion?()
				}
				alertController.addAction(okAction)
				rootViewController.present(alertController, animated: true, completion: nil)
			}
		}
	}
	
	static func infoAlert(_ title: String?, message: String?, completion: (() -> Void)? = nil) {
		DispatchQueue.main.async {
			AlertHelper.showAlert(title: title, message: message) {
				completion?()
			}
		}
	}
}
