//
//  DailyReportViewController.swift
//  SitFitDemo
//
//  Created by Lynn Smith on 12/12/14.
//  Copyright (c) 2014 Lynn Smith. All rights reserved.
//

import UIKit

class DailyReportViewController: UIViewController {

  
  @IBOutlet weak var scrollView: UIScrollView!
  
    override func viewDidLoad() {
      super.viewDidLoad()
      //scrollView.frame = CGRectMake(0, 0, 2000, 2000)
      //scrollView.scrollEnabled = true
      scrollView.contentSize = CGSizeMake(320, 900)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
