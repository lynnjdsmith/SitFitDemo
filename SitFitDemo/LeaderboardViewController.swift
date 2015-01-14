//
//  LeaderboardViewController.swift
//  SitFitDemo
//
//  Created by Lynn Smith on 12/12/14.
//  Copyright (c) 2014 Lynn Smith. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSizeMake(320, 900)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
}
