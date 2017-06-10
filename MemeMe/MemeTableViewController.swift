//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Petra Donka on 07.06.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import UIKit

private let reuseIdentifier = "memeTableViewCell"

class MemeTableViewCell: UITableViewCell {
    @IBOutlet var topLabel: UILabel!
    @IBOutlet var bottomLabel: UILabel!
    @IBOutlet var memeImageView: UIImageView!
}

class MemeTableViewController: UITableViewController, MemeController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - UITableViewDelegate, UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MemeTableViewCell
        let meme = memes[indexPath.row]

        return setupCell(cell, withMeme: meme)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meme = memes[indexPath.row]

        showMeme(meme)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeMeme(at: indexPath.row)
            deleteMemeRow(at: indexPath)
        }
    }

    func setupCell(_ cell: UITableViewCell, withMeme meme: Meme) -> UITableViewCell {
        if let cell = cell as? MemeTableViewCell {
            cell.memeImageView?.image = meme.memedImage
            cell.topLabel?.text = meme.topText
            cell.bottomLabel?.text = meme.bottomText
        }

        return cell
    }

    // Delete a row from the table
    func deleteMemeRow(at indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }

    // MARK: - MemeController

    func showMeme(_ meme: Meme) {
        if let detailController = storyboard?.instantiateViewController(withIdentifier: "memeDetailViewController") as? MemeDetailViewController {
            detailController.meme = meme
            navigationController?.pushViewController(detailController, animated: true)
        }
    }
}
