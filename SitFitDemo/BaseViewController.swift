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
  
  let screenSize: CGRect = UIScreen.mainScreen().bounds
  let menuHeight :CGFloat = 60.0
  var menuOpen = false  
  var menuWidth :CGFloat = 150
  var statusHeight = 20
  
  var bodyVC        :BodyViewController
  var movingGraphVC :UIViewController
  var dailyReportVC :DailyReportViewController
  var leaderboardVC :LeaderboardViewController
  var settingsVC    :SettingsViewController
  var overlay       :UIView
  
  var viewsArray :AnyObject = []

  
  required init(coder aDecoder: NSCoder) {
    let storyboard = UIStoryboard(name: "BaseView", bundle: nil)
    
    // Main Activity
    bodyVC = BodyViewController(nibName: "BodyViewController", bundle: nil)
    bodyVC.view.frame = CGRectMake(0, menuHeight, screenSize.width, screenSize.height - menuHeight)
    
    // Moving Graph
    movingGraphVC = GraphViewController(nibName: "GraphViewController", bundle: nil)
    movingGraphVC.view.frame = CGRectMake(0, menuHeight, screenSize.width, screenSize.height - menuHeight)
    
    // Daily Report
    dailyReportVC = DailyReportViewController(nibName: "DailyReportViewController", bundle: nil)
    dailyReportVC.view.frame = CGRectMake(0, menuHeight, screenSize.width, screenSize.height - menuHeight)
    
    // Leaderboard
    leaderboardVC = LeaderboardViewController(nibName: "LeaderboardViewController", bundle: nil)
    leaderboardVC.view.frame = CGRectMake(0, menuHeight, screenSize.width, screenSize.height - menuHeight)
    
    // Settings
    settingsVC = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
    settingsVC.view.frame = CGRectMake(0, menuHeight, screenSize.width, screenSize.height - menuHeight)
    
    
    overlay = UIView(frame: CGRectMake(menuWidth, menuHeight, screenSize.width, screenSize.height - menuHeight))
    
    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  
    dailyReportVC.delegate = self

    // setup overlay
    overlay.backgroundColor=UIColor.clearColor()
    let recognizer = UITapGestureRecognizer(target: self, action:Selector("closeMenu:"))
    self.overlay.addGestureRecognizer(recognizer)
    self.view.addSubview(overlay)
    
    // add view controllers
    self.view.addSubview(overlay)
    self.view.addSubview(bodyVC.view)
    self.view.addSubview(movingGraphVC.view)
    self.view.addSubview(dailyReportVC.view)
    self.view.addSubview(leaderboardVC.view)
    self.view.addSubview(settingsVC.view)
    
    self.view.bringSubviewToFront(bodyVC.view)
    
  }
  
  func closeMenu(recognizer : UIRotationGestureRecognizer) {
    menuButtonToggle(self)
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
      overlay.hidden = true     // inelegant. shouldn't need this.
      menuOpen = false
    } else {        // open
      animateCenterPanelXPosition(targetPosition: menuWidth)
      self.view.bringSubviewToFront(overlay)
      overlay.hidden = false
      menuOpen = true
    }
  }

  @IBAction func bodyButtonPressed(sender: AnyObject) {
    self.menuButtonToggle(self)
    self.view.bringSubviewToFront(bodyVC.view)
  }
  
  @IBAction func movingGraphButtonPressed(sender: AnyObject) {
    self.menuButtonToggle(self)
    self.view.bringSubviewToFront(movingGraphVC.view)
  }
  
  @IBAction func dailyReportButtonPressed(sender: AnyObject) {
    self.menuButtonToggle(self)
    self.view.bringSubviewToFront(dailyReportVC.view)
  }

  @IBAction func leaderboardButtonPressed(sender: AnyObject) {
    self.menuButtonToggle(self)
    self.view.bringSubviewToFront(leaderboardVC.view)
  }
  
  @IBAction func settingsButtonPressed(sender: AnyObject) {
    self.menuButtonToggle(self)
    self.view.bringSubviewToFront(settingsVC.view)
  }

  
  func animateCenterPanelXPosition(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
    UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
      self.bodyVC.view.frame.origin.x = targetPosition
      self.movingGraphVC.view.frame.origin.x = targetPosition
      self.dailyReportVC.view.frame.origin.x = targetPosition
      self.leaderboardVC.view.frame.origin.x = targetPosition
      self.settingsVC.view.frame.origin.x = targetPosition
      }, completion: completion)
  }
  
}

