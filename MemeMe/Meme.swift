//
//  Meme.swift
//  MemeMe
//
//  Created by Petra Donka on 01.05.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import Foundation
import UIKit

class Meme {

    var backgroundImage: UIImage
    var topText: String
    var bottomText: String
    var memedImage: UIImage

    init(withImage image: UIImage, topText top: String, bottomText bottom: String, memedImage meme: UIImage) {
        backgroundImage = image
        topText = top
        bottomText = bottom
        memedImage = meme
    }
}
