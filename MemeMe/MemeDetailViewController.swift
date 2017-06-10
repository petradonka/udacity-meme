//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Petra Donka on 10.06.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    var meme: Meme?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMemeDetails()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareMeme))
    }

    func setupMemeDetails() {
        if let meme = meme {
            imageView.image = meme.memedImage
        }
    }

    func shareMeme() {
        if let memedImage = meme?.memedImage {
            let activityViewController = UIActivityViewController.init(activityItems: [memedImage], applicationActivities: nil)
            activityViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            //        activityViewController.completionWithItemsHandler = nil

            present(activityViewController, animated: true)
        }
    }
}
