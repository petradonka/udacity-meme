//
//  Meme.swift
//  MemeMe
//
//  Created by Petra Donka on 01.05.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import Foundation
import UIKit

let defaultMemeFontAttributes: FontAttributes = [
    NSStrokeColorAttributeName: UIColor.white,
    NSStrokeWidthAttributeName: -6.0, // setting a negative value strokes AND fills the text
    NSForegroundColorAttributeName: UIColor.black,
    NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
]

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

    var alternativeMemedImage: UIImage {
        return alternateGenerateMemedImage()
    }

    func alternateGenerateMemedImage() -> UIImage {
        let topAttributes = generateMemeFontAttributes(withText: topText, forImage: backgroundImage)
        let bottomAttributes = generateMemeFontAttributes(withText: bottomText, forImage: backgroundImage)

        var memedImage = backgroundImage.addText(topText, atLocation: .top, withAttributes: topAttributes)
        memedImage = memedImage.addText(bottomText, atLocation: .bottom, withAttributes: bottomAttributes)

        return memedImage
    }

    func generateMemeFontAttributes(withText text: String, forImage image: UIImage) -> FontAttributes {
        var newAttributes = defaultMemeFontAttributes
        let maxFontSize = image.size.width / 10
        let minFontSize = image.size.width / 50

        var bestFontSize = maxFontSize
        newAttributes[NSFontAttributeName] = (newAttributes[NSFontAttributeName] as! UIFont).withSize(bestFontSize)

        while text.size(attributes: newAttributes).width > image.size.width && bestFontSize > minFontSize {
            bestFontSize -= 10
            newAttributes[NSFontAttributeName] = (newAttributes[NSFontAttributeName] as! UIFont).withSize(bestFontSize)
        }
        newAttributes[NSStrokeWidthAttributeName] = -1 * (bestFontSize / 50)
        return newAttributes
    }
}
