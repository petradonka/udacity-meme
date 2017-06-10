//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Petra Donka on 07.06.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import UIKit

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTableViewCell", for: indexPath) as! MemeTableViewCell
        let meme = memes[indexPath.row]

        cell.memeImageView?.image = meme.memedImage
        cell.topLabel?.text = meme.topText
        cell.bottomLabel?.text = meme.bottomText

        return cell
    }
}
