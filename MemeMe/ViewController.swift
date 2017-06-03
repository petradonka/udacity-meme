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

    var topTextFieldConstraint: NSLayoutConstraint?
    var bottomTextFieldConstraint: NSLayoutConstraint?

    let defaultMemeTextAttributes: [String:Any] = [
        NSStrokeColorAttributeName: UIColor.white,
        NSStrokeWidthAttributeName: -6.0, // setting a negative value strokes AND fills the text
        NSForegroundColorAttributeName: UIColor.black,
        NSFontAttributeName: UIFont(name: "Impact", size: 40)!,
        ]

    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribe()
    }

    override func viewWillDisappear(_ animated: Bool) {
        unsubscribe()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        setUI(hasImage: false)
    }

    // MARK: - Initializations & related handlers

    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }

    func setupTextFields() {
        topTextField.defaultTextAttributes = defaultMemeTextAttributes
        bottomTextField.defaultTextAttributes = defaultMemeTextAttributes
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

    // Dismiss keyboard if tapped outside of a text field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        for touch in touches where type(of: touch.view) != UITextField.self {
            touch.view?.endEditing(true)
        }
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

    // Helper method for pushing up the keyboard
    func pushViewUpForKeyboard(withHeight height: CGFloat?) {
        if let keyboardHeight = height {
            if topTextField.isFirstResponder {
                if topTextField.frame.origin.y + topTextField.frame.height > view.frame.height - keyboardHeight {
                    view.frame.origin.y = 0 - keyboardHeight
                }
            } else if bottomTextField.isFirstResponder {
                // TODO: push only if really needed! right now it still pushes too high
                // idea: create function to calculate the needed push to isolate that part, maybe extract it into an extension to be reused later and to separate it even more
                if bottomTextField.frame.origin.y + bottomTextField.frame.height > view.frame.height - keyboardHeight {
                    view.frame.origin.y = 0 - keyboardHeight
                }
            }
        }
    }

    // MARK: - IBActions

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
            activityViewController.completionWithItemsHandler = { _ in self.saveMeme(image, top, bottom, memedImage)}

            present(activityViewController, animated: true)
        } else {
            print("not enough stuff")
        }
    }

    // MARK: - Meme helpers

    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        setUIForCapturingMeme(shouldHideTopBottomBars: true)

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // Show toolbar and navbar
        setUIForCapturingMeme(shouldHideTopBottomBars: false)

        return memedImage
    }

    func saveMeme(_ image: UIImage, _ top: String, _ bottom: String, _ memedImage: UIImage) {
        let meme = Meme.init(withImage: image, topText: top, bottomText: bottom, memedImage: memedImage)
        print(meme)
    }

    // MARK: - UI helpers

    func setUIForCapturingMeme(shouldHideTopBottomBars: Bool = false) {
        self.navigationController?.setToolbarHidden(shouldHideTopBottomBars, animated: false)
        self.navigationController?.setNavigationBarHidden(shouldHideTopBottomBars, animated: false)
        statusBarHidden = shouldHideTopBottomBars
        self.setNeedsStatusBarAppearanceUpdate()
    }

    func setUI(hasImage: Bool, image: UIImage? = nil) {
        shareButton.isEnabled = hasImage
        topTextField.isHidden = !hasImage
        bottomTextField.isHidden = !hasImage

        if let newImage = image {
            imageView.image = newImage

            positionTextFields(inView: imageView)
        }
    }

    func positionTextFields(inView view: UIImageView) {
        let imageViewWidth = view.frame.width

        if topTextFieldConstraint === nil {
            topTextFieldConstraint = topTextField.topAnchor.constraint(equalTo: view.topAnchor)
            if let topTextFieldConstraint = topTextFieldConstraint {
                topTextFieldConstraint.identifier = "topTextFieldConstraint"
                topTextFieldConstraint.isActive = true
            }
        }

        if bottomTextFieldConstraint === nil {
            bottomTextFieldConstraint = bottomTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            if let bottomTextFieldConstraint = bottomTextFieldConstraint {
                bottomTextFieldConstraint.identifier = "bottomTextFieldConstraint"
                bottomTextFieldConstraint.isActive = true
            }
        }

        if let imageHeight = view.image?.size.height,
            let imageWidth = view.image?.size.width,
            let topTextFieldConstraint = topTextFieldConstraint,
            let bottomTextFieldConstraint = bottomTextFieldConstraint {
            let scaleFactor = imageViewWidth / imageWidth
            let newImageHeight = imageHeight * scaleFactor

            let imageTopToViewTop = view.frame.height/2 - newImageHeight/2
            let imageBottomToViewBottom = view.frame.height/2 - newImageHeight/2

            topTextFieldConstraint.constant = imageTopToViewTop;
            bottomTextFieldConstraint.constant = -1 * imageBottomToViewBottom
            view.updateConstraintsIfNeeded()
        }
    }
}
