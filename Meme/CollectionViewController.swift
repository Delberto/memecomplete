//
//  CollectionViewController.swift
//  Meme
//
//  Created by Delberto Martinez on 07/07/16.
//  Copyright © 2016 Delberto Martinez. All rights reserved.
//

import UIKit
import Foundation


class CollectionViewController: UICollectionViewController{
    

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var navigationBar: UINavigationItem!
   
    

    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 5.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView?.reloadData()
        
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
       override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        let meme = memes[indexPath.item]
        let imageView = UIImageView(image: meme.memedImage)
        cell.backgroundView = imageView
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        controller.memeDetail = memes[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
