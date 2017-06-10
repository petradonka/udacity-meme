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

        if let meme = meme {
            imageView.image = meme.memedImage
        }
    }
}
