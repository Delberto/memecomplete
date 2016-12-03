//
//  MemeDetailViewController.swift
//  Meme
//
//  Created by Delberto Martinez on 20/07/16.
//  Copyright © 2016 Delberto Martinez. All rights reserved.
//

import UIKit
import Foundation

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var memeDetailImage: UIImageView!
 
    var memeDetail: Meme!
    var memeText: Meme!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        self.memeDetailImage!.image = memeDetail.memedImage
        
    
        }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
}
