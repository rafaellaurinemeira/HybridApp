//
//  CameraUtils.swift
//  HybridApp
//
//  Created by Rafael Laurine Meira on 21/08/17.
//  Copyright © 2017 RLDeveloper. All rights reserved.
//

import Foundation
import Photos
import AVFoundation

open class CameraUtils: NSObject {
    let picker = UIImagePickerController()
    
    var success = ""
    var error = ""
    var quality: CGFloat = 1.0
    
    open func open(_ success: String, error: String, with quality: Int) {
        self.success = success
        self.error = error
        self.quality = CGFloat(quality)/100
        let alert = UIAlertController(title: "Image", message: "Choose", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Library", style: .default) {_ in
            PHPhotoLibrary.requestAuthorization{permission in
                if permission == .authorized {
                    guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
                    self.picker.sourceType = .photoLibrary
                    self.picker.delegate = self
                    DispatchQueue.main.async { Singleton.shared.present(self.picker, animated: true) }
                }
            }
        })
        alert.addAction(UIAlertAction(title: "Camera", style: .default) {_ in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
            self.picker.sourceType = .camera
            self.picker.cameraCaptureMode = .photo
            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for:.camera)!
            self.picker.delegate = self
            DispatchQueue.main.async { Singleton.shared.present(self.picker, animated: true) }
        })
        DispatchQueue.main.async { Singleton.shared.present(alert, animated: true, completion: nil) }
    }
}

// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension CameraUtils: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        defer { picker.dismiss(animated: true) }
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            Singleton.shared.executeJS("\(error)(\"File is not a image\")")
            return
        }
        let name = "\(NSDate().timeIntervalSince1970 * 1000).jpg"
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let photoURL = NSURL(fileURLWithPath: dir)
        guard let localPath = photoURL.appendingPathComponent(name) else {
            Singleton.shared.executeJS("\(error)(\"File is not a image\")")
            return
        }
        if let imageRef = UIImageJPEGRepresentation(image, quality), let _ = try? imageRef.write(to: localPath) {
            let path = localPath.absoluteString.replacingOccurrences(of: "file://", with: "")
            Singleton.shared.executeJS("\(success)(\"\(path)\")")
        } else {
            Singleton.shared.executeJS("\(error)(\"File is not a image\")")
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        defer { picker.dismiss(animated: true) }
        Singleton.shared.executeJS("\(error)(\"Cancel is tapped\")")
    }
}
