//
//  UIImageExtension.swift
//  MemeMe
//
//  Created by Petra Donka on 01.05.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import Foundation
import UIKit

enum TextLocation { case top, bottom }

typealias FontAttributes = [String:Any]

extension UIImage {    
    func addText(_ text: String, inRect textRect: CGRect, withAttributes fontAttributes: FontAttributes) -> UIImage {
        // Setup the image context using the passed image
        UIGraphicsBeginImageContext(size)

        // Put the image into a rectangle as large as the original image
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

        // Draw the text into an image
        text.draw(in: textRect, withAttributes: fontAttributes)

        // Create a new image out of the images we have created
        let newImage = UIGraphicsGetImageFromCurrentImageContext()

        // End the context now that we have the image we need
        UIGraphicsEndImageContext()

        //Pass the image back up to the caller
        return newImage!
    }

    func addText(_ text: String, atLocation textLocation: TextLocation, withAttributes fontAttributes: FontAttributes) -> UIImage {
        var textRect: CGRect
        let textSize = text.size(attributes: fontAttributes)

        switch textLocation {
        case .top:
            textRect = CGRect(x: size.width / 2 - textSize.width / 2,
                              y: size.height * 0.05,
                              width: textSize.width,
                              height: textSize.height)

        case .bottom:
            textRect = CGRect(x: size.width / 2 - textSize.width / 2,
                              y: size.height - size.height * 0.05 - textSize.height,
                              width: textSize.width,
                              height: textSize.height)
        }

        return addText(text, inRect: textRect, withAttributes: fontAttributes)
    }
}
