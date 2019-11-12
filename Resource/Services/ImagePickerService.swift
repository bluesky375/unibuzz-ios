//
//  ImagePickerService.swift
//  Grubs-up
//
//  Created by Ahmed Durrani on 26/05/2019.
//  Copyright © 2019 CyberHost. All rights reserved.
//


import UIKit
  

protocol ImagePickerServiceDelegate: class {
    func didPickImage(_ image: Data)
}

class ImagePickerService: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    weak var delegate: ImagePickerServiceDelegate?
    
    func showImagePicker(on viewController: UIViewController?) {
        let context = (self)
        
        let alertController = UIAlertController(title: "Pick Image From".localized(), message: nil, preferredStyle: .actionSheet)
        
        let photoLibrary = UIAlertAction(title: "Photo Library".localized(), style: .default) { (action) in
            context.showImagePicker(with: .photoLibrary, on: viewController)
        }
        
        let camera = UIAlertAction(title: "Camera".localized(), style: .default) { (action) in
            context.showImagePicker(with: .camera, on: viewController)
        }
        
        let cancel = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
        
        alertController.addAction(photoLibrary)
        alertController.addAction(camera)
        alertController.addAction(cancel)
        
        viewController?.showDetailViewController(alertController, sender: viewController)
    }
    
    private func showImagePicker(with sourceType: UIImagePickerController.SourceType, on viewController: UIViewController?) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        viewController?.showDetailViewController(imagePicker, sender: viewController)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage, let data = image.jpegData(compressionQuality: 0.4) else {
            return
        }
        
        delegate?.didPickImage(data)
        picker.dismiss(animated: true, completion: nil)
    }
}
