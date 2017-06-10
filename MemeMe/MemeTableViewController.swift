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

class MemeTableViewController: UITableViewController {

    var memes: [Meme] = [Meme]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMemes()
    }

    func loadMemes() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            memes = appDelegate.memes
            tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MemeTableViewCell
        let meme = memes[indexPath.row]

        cell.memeImageView?.image = meme.memedImage
        cell.topLabel?.text = meme.topText
        cell.bottomLabel?.text = meme.bottomText

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meme = memes[indexPath.row]

        if let detailController = storyboard?.instantiateViewController(withIdentifier: "memeDetailViewController") as? MemeDetailViewController {
            detailController.meme = meme

            navigationController?.pushViewController(detailController, animated: true)
        }
    }
}
