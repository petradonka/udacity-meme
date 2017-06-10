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

    var memes: [Meme] {
        get {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                return appDelegate.memes
            } else {
                return [Meme]()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Meme Operations

    func removeMeme(at indexPath: IndexPath) {
        tableView.beginUpdates()

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.memes.remove(at: indexPath.row)
        }
        tableView.deleteRows(at: [indexPath], with: .automatic)

        tableView.endUpdates()
    }

    // MARK: - UITableViewDelegate, UITableViewDataSource

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

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeMeme(at: indexPath)
        }
    }
}
