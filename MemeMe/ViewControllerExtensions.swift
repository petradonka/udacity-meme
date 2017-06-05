//
//  ViewControllerExtensions.swift
//  MemeMe
//
//  Created by Petra Donka on 11.05.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import Foundation
import UIKit

extension MemeEditorViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let text = textField.text, text == defaultTopText || text == defaultBottomText {
            if (textField === topTextField && text == defaultTopText)
                || (textField === bottomTextField && text == defaultBottomText) {
                textField.text = ""
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)

        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            setUI(hasImage: true, image: image)
        } else {
            print("Something went wrong... There's no image...")
        }
        
    }
}
