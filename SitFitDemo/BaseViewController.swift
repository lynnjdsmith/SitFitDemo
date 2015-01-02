//
//  ViewController.swift
//  SitFitDemo
//
//  Created by Lynn Smith on 12/10/14.
//  Copyright (c) 2014 Lynn Smith. All rights reserved.
//

import UIKit
import QuartzCore

class BaseViewController: UIViewController, oneDelegate { //customClassDelegate {

  @IBOutlet weak var menuButton: UIButton!
  @IBOutlet weak var monitorButton: UIButton!
  @IBOutlet weak var dailyReportButton: UIButton!
  @IBOutlet weak var leaderboardButton: UIButton!
  @IBOutlet weak var pickViewButton: UIButton!
  @IBOutlet weak var settingsButton: UIButton!
  
  let screenSize: CGRect = UIScreen.mainScreen().bounds
  let menuHeight :CGFloat = 60.0
  var menuOpen = false  
  var menuWidth = 160
  var statusHeight = 20
  
  //var mainActivityVC :UITableViewController
  //var activityVC :UIViewController
  var movingGraphVC :UIViewController
  var dailyReportVC :DailyReportViewController
  var leaderboardVC :LeaderboardViewController
  //var pickNodeVC :UITableViewController
  var settingsVC :SettingsViewController

  var viewsArray :AnyObject = []

  
  required init(coder aDecoder: NSCoder) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    // Main
    //let pickNodeVC = storyboard.instantiateViewControllerWithIdentifier("VTNodeConnectionManagerViewController") as UITableViewController
    //pickNodeVC.view.frame = CGRectMake(0, menuHeight, screenSize.width, screenSize.height - menuHeight)
    //self.pickNodeVC = pickNodeVC
    //self.viewsArray.addObject(self.mainActivityVC)
    
    //let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ViewController") as UIViewController
    // .instantiatViewControllerWithIdentifier() returns AnyObject! this must be downcast to utilize it
    //self.presentViewController(viewController, animated: false, completion: nil)
    
    // Activity
    //let activityVC = storyboard.instantiateViewControllerWithIdentifier("VTMotionViewController") as UIViewController
    //var activityVC = SettingsViewController(nibName: "VTMotionViewController", bundle: nil)
    //activityVC.view.frame = CGRectMake(0, menuHeight, screenSize.width, screenSize.height - menuHeight)
    //self.activityVC = activityVC
    //self.viewsArray.addObject(self.activityVC)
    
    // Moving Graph
    let movingGraphVC = GraphViewController(nibName: "GraphViewController", bundle: nil)
    movingGraphVC.view.frame = CGRectMake(0, menuHeight, screenSize.width, screenSize.height - menuHeight)
    self.movingGraphVC = movingGraphVC
    //self.viewsArray.addObject(self.activityVC)
    
    // Daily Report
    var dailyReportVC = DailyReportViewController(nibName: "DailyReportViewController", bundle: nil)
    dailyReportVC.view.frame = CGRectMake(0, menuHeight, screenSize.width, screenSize.height - menuHeight)
    self.dailyReportVC = dailyReportVC
    //self.viewsArray.addObject(self.dailyReportVC)
    
    // Leaderboard
    var leaderboardVC = LeaderboardViewController(nibName: "LeaderboardViewController", bundle: nil)
    leaderboardVC.view.frame = CGRectMake(0, menuHeight, screenSize.width, screenSize.height - menuHeight)
    self.leaderboardVC = leaderboardVC
    //self.viewsArray.addObject(self.leaderboardVC)
    
    // Settings
    var settingsVC = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
    settingsVC.view.frame = CGRectMake(0, menuHeight, screenSize.width, screenSize.height - menuHeight)
    self.settingsVC = settingsVC
    //self.viewsArray.addObject(self.settingsVC)
    

    
    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  
    dailyReportVC.delegate = self
    
    // add view controllers
    //self.view.addSubview(activityVC.view)
    self.view.addSubview(movingGraphVC.view)
    self.view.addSubview(dailyReportVC.view)
    self.view.addSubview(leaderboardVC.view)
    self.view.addSubview(settingsVC.view)

    
    // hide everything
    dailyReportVC.view.hidden = true
    leaderboardVC.view.hidden = true
    settingsVC.view.hidden = true
  }
  
  func sayHello() {
    println("Say Hello - DONE IT!! *******")
  }
  
  
  func didPress1(val: NSString) {
    //self.menuBtn1("sendPlaceHolder")
    println("DONE IT!! ******* val: \(val)")
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

  /* @IBAction func menuBtn1(sender: AnyObject) {
    //println("monitor")
    self.hideVCs()
    activityVC.view.hidden = false
    self.view.bringSubviewToFront(activityVC.view)
    self.menuButtonToggle(self)
  } */
  
  @IBAction func movingGraphButtonPressed(sender: AnyObject) {
    self.hideVCs()
    movingGraphVC.view.hidden = false
    self.view.bringSubviewToFront(movingGraphVC.view)
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
  
  /* @IBAction func pickNodeButtonPressed(sender: AnyObject) {
    self.hideVCs()
    pickNodeVC.view.hidden = false
    self.view.bringSubviewToFront(pickNodeVC.view)
    self.menuButtonToggle(self)
  } */
  
  @IBAction func settingsButtonPressed(sender: AnyObject) {
        //println("settings")
    self.hideVCs()
    settingsVC.view.hidden = false
    self.view.bringSubviewToFront(settingsVC.view)
    self.menuButtonToggle(self)
  }

  func activityViewShow(sender: AnyObject) {
  /*   self.hideVCs()
    activityVC.view.hidden = false
    self.view.bringSubviewToFront(activityVC.view)
    self.menuButtonToggle(self) */
  }
  
  func hideVCs() {
    /* for item in self.viewsArray {
      println(item)
    } */
    
    //activityVC.view.hidden = true
    dailyReportVC.view.hidden = true
    movingGraphVC.view.hidden = true
    leaderboardVC.view.hidden = true
    settingsVC.view.hidden = true

  }
  
  func animateCenterPanelXPosition(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
    UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
      //self.activityVC.view.frame.origin.x = targetPosition
      self.movingGraphVC.view.frame.origin.x = targetPosition
      self.dailyReportVC.view.frame.origin.x = targetPosition
      self.leaderboardVC.view.frame.origin.x = targetPosition
      self.settingsVC.view.frame.origin.x = targetPosition
      }, completion: completion)
  }
  
}

