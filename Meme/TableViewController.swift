//
//  TableViewController.swift
//  Meme
//
//  Created by Delberto Martinez on 07/07/16.
//  Copyright © 2016 Delberto Martinez. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView?.reloadData()
    }
    
    
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
        as! TableCell
        let memeTable = memes[indexPath.row]
        tableCell.imageView?.image = memeTable.memedImage
        return tableCell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        controller.memeDetail = memes[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    }


