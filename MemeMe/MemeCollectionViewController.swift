//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Petra Donka on 10.06.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import UIKit

private let reuseIdentifier = "memeCollectionViewCell"

class MemeCollectionViewCell: UICollectionViewCell {
    @IBOutlet var memeImageView: UIImageView!
}

class MemeCollectionViewController: UICollectionViewController, MemeController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()
        clearsSelectionOnViewWillAppear = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribe()
        setupFlowLayout()
        collectionView?.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribe()
    }

    func subscribe() {
        NotificationCenter.default.addObserver(self, selector: #selector(setupFlowLayout), name: .UIDeviceOrientationDidChange, object: nil)
    }

    func unsubscribe() {
        NotificationCenter.default.removeObserver(self, name: .UIDeviceOrientationDidChange, object: nil)
    }

    func setupFlowLayout() {
        let space: CGFloat = 1

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = calculateFlowLayoutItemSize(withSpacing: space)
    }

    func calculateFlowLayoutItemSize(withSpacing space: CGFloat) -> CGSize {
        let approximateItemMinSize: CGFloat
        if let smallerScreenSide = [view.frame.size.width, view.frame.size.height].min() {
            approximateItemMinSize = smallerScreenSide / 3
        } else {
            approximateItemMinSize = 120
        }

        let rowLength = view.frame.size.width
        let numberOfItemsInRow: CGFloat = (rowLength / approximateItemMinSize).rounded()
        let allSpacingInRow = (numberOfItemsInRow - 1) * space
        let itemDimension = (rowLength - allSpacingInRow) / numberOfItemsInRow

        return CGSize(width: itemDimension, height: itemDimension)
    }

    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]

        cell.memeImageView?.image = meme.memedImage
    
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meme = memes[indexPath.row]

        showMeme(meme)
    }

    // MARK: - MemeController

    func showMeme(_ meme: Meme) {
        if let detailController = storyboard?.instantiateViewController(withIdentifier: "memeDetailViewController") as? MemeDetailViewController {
            detailController.meme = meme
            navigationController?.pushViewController(detailController, animated: true)
        }
    }
}
