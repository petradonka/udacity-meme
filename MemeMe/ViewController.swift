//
//  ViewController.swift
//  MemeMe
//
//  Created by Petra Donka on 01.05.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!
    var statusBarHidden: Bool = false

    let defaultTopText = "TOP"
    let defaultBottomText = "BOTTOM"

    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = false
        subscribe()
    }

    override func viewWillDisappear(_ animated: Bool) {
        unsubscribe()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
    }

    func setupTextFields() {
        let memeTextAttributes: [String:Any] = [
            NSStrokeColorAttributeName: UIColor.white,
            NSStrokeWidthAttributeName: -6.0, // setting a negative value strokes AND fills the text
            NSForegroundColorAttributeName: UIColor.black,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            ]

        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
        topTextField.text = defaultTopText
        bottomTextField.text = defaultBottomText
    }

    func subscribe() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }

    func unsubscribe() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

    func keyboardWillShow(_ notification: Notification) {
        let keyboardHeight = getKeyboardHeightForNotification(notification)
        pushViewUpForKeyboard(withHeight: keyboardHeight)
    }

    func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }

    func getKeyboardHeightForNotification(_ notification: Notification) -> CGFloat? {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue
        return keyboardSize?.cgRectValue.height
    }

    func pushViewUpForKeyboard(withHeight height: CGFloat?) {
        // calculate shift amount based on other values
        if let keyboardHeight = height {
            if topTextField.isFirstResponder {
                if topTextField.frame.origin.y + topTextField.frame.height > view.frame.height - keyboardHeight {
                    view.frame.origin.y = 0 - keyboardHeight
                }
            } else if bottomTextField.isFirstResponder {
                if bottomTextField.frame.origin.y + bottomTextField.frame.height > view.frame.height - keyboardHeight {
                    view.frame.origin.y = 0 - keyboardHeight
                }
            } else {
                print("why is the keyboard showing up? 🤔")
            }
        } else {
            // TODO: handle error properly
            print("there was no valid keyboard height, which is highly unlikely")
        }
    }

    @IBAction func choosePhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self

        present(imagePicker, animated: true, completion: nil)
        
    }

    @IBAction func shootPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self

        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func shareMeme() {
        if let image = imageView.image, let top = topTextField.text, let bottom = bottomTextField.text {
            let memedImage = generateMemedImage()
            let activityViewController = UIActivityViewController.init(activityItems: [memedImage], applicationActivities: nil)

            activityViewController.completionWithItemsHandler = { (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
                // TODO: handle something here
                print(activityType ?? "nothing")
                print(completed)

                self.saveMeme(image, top, bottom, memedImage);
            }

            present(activityViewController, animated: true)
        } else {
            print("not enough stuff")
        }
    }

    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        setUI(shouldHideTopBottomBars: true)

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // Show toolbar and navbar
        setUI(shouldHideTopBottomBars: false)

        return memedImage
    }

    func saveMeme(_ image: UIImage, _ top: String, _ bottom: String, _ memedImage: UIImage) {
        let _ = Meme.init(withImage: image, topText: top, bottomText: bottom, memedImage: memedImage)
    }

    func setUI(shouldHideTopBottomBars: Bool = false) {
        self.navigationController?.setToolbarHidden(shouldHideTopBottomBars, animated: false)
        self.navigationController?.setNavigationBarHidden(shouldHideTopBottomBars, animated: false)
        statusBarHidden = shouldHideTopBottomBars
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }

}
