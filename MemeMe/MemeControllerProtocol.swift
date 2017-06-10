//
//  MemeControllerProtocol.swift
//  MemeMe
//
//  Created by Petra Donka on 10.06.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import Foundation
import UIKit

protocol MemeController {
    var memes: [Meme] {
        get
    }

    func removeMeme(at index: Int)
    func showMeme(_ meme: Meme)
}

extension MemeController {
    var memes: [Meme] {
        get {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                return appDelegate.memes
            } else {
                return [Meme]()
            }
        }
    }

    // Remove meme from the shared model
    func removeMeme(at index: Int) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.memes.remove(at: index)
        }
    }
}
