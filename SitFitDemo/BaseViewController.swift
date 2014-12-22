//
//  ViewController.swift
//  SitFitDemo
//
//  Created by Lynn Smith on 12/10/14.
//  Copyright (c) 2014 Lynn Smith. All rights reserved.
//

import UIKit
import QuartzCore

class BaseViewController: UIViewController {

  @IBOutlet weak var menuButton: UIButton!
  @IBOutlet weak var monitorButton: UIButton!
  @IBOutlet weak var dailyReportButton: UIButton!
  @IBOutlet weak var leaderboardButton: UIButton!
  @IBOutlet weak var settingsButton: UIButton!
  
  let screenSize: CGRect = UIScreen.mainScreen().bounds
  let menuHeight :CGFloat = 60.0
  var menuOpen = false  
  var menuWidth = 160
  var statusHeight = 20
  
  var mainActivityVC :UITableViewController
  var dailyReportVC :DailyReportViewController
  var leaderboardVC :LeaderboardViewController
  var settingsVC :SettingsViewController

  required init(coder aDecoder: NSCoder) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let mainActivityVC = storyboard.instantiateViewControllerWithIdentifier("VTNodeConnectionManagerViewController") as UITableViewController
    //self.presentViewController(vc, animated: true, completion: nil)
    
    mainActivityVC.view.frame = CGRectMake(0, menuHeight, screenSize.width, screenSize.height - menuHeight)
    self.mainActivityVC = mainActivityVC

    var dailyReportVC = DailyReportViewController(nibName: "DailyReportViewController", bundle: nil)
    dailyReportVC.view.frame = CGRectMake(0, menuHeight, screenSize.width, screenSize.height - menuHeight)
    self.dailyReportVC = dailyReportVC

    var leaderboardVC = LeaderboardViewController(nibName: "LeaderboardViewController", bundle: nil)
    leaderboardVC.view.frame = CGRectMake(0, menuHeight, screenSize.width, screenSize.height - menuHeight)
    self.leaderboardVC = leaderboardVC
    
    var settingsVC = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
    settingsVC.view.frame = CGRectMake(0, menuHeight, screenSize.width, screenSize.height - menuHeight)
    self.settingsVC = settingsVC
    
    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  
    // add view controllers
    self.view.addSubview(mainActivityVC.view)
    self.view.addSubview(dailyReportVC.view)
    self.view.addSubview(leaderboardVC.view)
    self.view.addSubview(settingsVC.view)
    
    // hide everything but main
    dailyReportVC.view.hidden = true
    leaderboardVC.view.hidden = true
    settingsVC.view.hidden = true
  }

  
  @IBAction func menuButtonToggle(sender: AnyObject) {
    //println("menu clicked")
    if (menuOpen) { // close
      animateCenterPanelXPosition(targetPosition: 0)
      menuOpen = false
    } else {        // open
      animateCenterPanelXPosition(targetPosition: 150)
      menuOpen = true
      
    }
  }

  @IBAction func menuBtn1(sender: AnyObject) {
    //println("monitor")
    self.hideVCs()
    mainActivityVC.view.hidden = false
    self.view.bringSubviewToFront(mainActivityVC.view)
    self.menuButtonToggle(self)
  }
  
  @IBAction func dailyReportButtonPressed(sender: AnyObject) {
    //println("report")
    self.hideVCs()
    dailyReportVC.view.hidden = false
    self.view.bringSubviewToFront(dailyReportVC.view)
    self.menuButtonToggle(self)
  }

  @IBAction func leaderboardButtonPressed(sender: AnyObject) {
        //println("leaderboard")
    self.hideVCs()
    leaderboardVC.view.hidden = false
    self.view.bringSubviewToFront(leaderboardVC.view)
    self.menuButtonToggle(self)
  }
  
  @IBAction func settingsButtonPressed(sender: AnyObject) {
        //println("settings")
    self.hideVCs()
    settingsVC.view.hidden = false
    self.view.bringSubviewToFront(settingsVC.view)
    self.menuButtonToggle(self)
  }
  
  func hideVCs() {
    mainActivityVC.view.hidden = true
    dailyReportVC.view.hidden = true
    leaderboardVC.view.hidden = true
    settingsVC.view.hidden = true
  }
  
  func animateCenterPanelXPosition(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
    UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
      self.mainActivityVC.view.frame.origin.x = targetPosition
      self.dailyReportVC.view.frame.origin.x = targetPosition
      self.leaderboardVC.view.frame.origin.x = targetPosition
      self.settingsVC.view.frame.origin.x = targetPosition
      }, completion: completion)
  }
  
}

