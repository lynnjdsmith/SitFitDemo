//
//  MainActivityViewController.swift
//  SitFitDemo
//
//  Created by Lynn Smith on 12/12/14.
//  Copyright (c) 2014 Lynn Smith. All rights reserved.
//

import UIKit

class BodyViewController: UIViewController {

  @IBOutlet weak var muscles_sides    :UIImageView!
  @IBOutlet weak var muscles_middle   :UIImageView!
  @IBOutlet weak var muscles_thigh    :UIImageView!
  
  
  override func viewDidLoad() {
      super.viewDidLoad()

    NSNotificationCenter.defaultCenter().addObserver(self, selector: "notifiedOfMovement:", name: GraphViewMovementNotification, object: nil)
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
    
  @IBAction func Btn1(sender: AnyObject) {
    showMovement(muscles_sides)
  }
  
  @IBAction func Btn2(sender: AnyObject) {
    showMovement(muscles_middle)
  }
  
  @IBAction func Btn3(sender: AnyObject) {
    showMovement(muscles_thigh)
  }
  
  func notifiedOfMovement(notification: NSNotification){
    //println(notification.userInfo?)
  
    
    if let id:VTSensorReading = notification.userInfo?["reading"] as? VTSensorReading {
      //println(id.x)
    }
    
    
    
    
    /* if let s:VTSensorReading = userInfo?["VTSensorReading"] as? VTSensorReading {
      // When we get here, we know "ID" is a valid key
      // and that the value is a String.
      var theReading = s
      println(s.x)
    } */
    //var theReading = notification.userInfo?["VTSensorReading"] as? VTSensorReading
    //println(theReading)
  }
  
  
  func showMovement(theImage: UIImageView) {
    animateImageViewOn(theImage)
  }
  
  func animateImageViewOn(theImage: UIImageView) {
    CATransaction.begin()
    CATransaction.setAnimationDuration(0.8)
    let transition = CATransition()
    transition.type = kCATransitionReveal
    theImage.layer.addAnimation(transition, forKey: kCATransition)
    CATransaction.setCompletionBlock {
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.8 * NSTimeInterval(NSEC_PER_SEC))), dispatch_get_main_queue()) {
        self.animateImageViewOff(theImage)
      }
    }
    CATransaction.commit()
    theImage.hidden = false
  }
  
  func animateImageViewOff(theImage: UIImageView) {
    CATransaction.begin()
    CATransaction.setAnimationDuration(0.8)
    let transition = CATransition()
    transition.type = kCATransitionFade
    theImage.layer.addAnimation(transition, forKey: kCATransition)
    CATransaction.commit()
    theImage.hidden = true
  }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
