//
//  MainActivityViewController.swift
//  SitFitDemo
//
//  Created by Lynn Smith on 12/12/14.
//  Copyright (c) 2014 Lynn Smith. All rights reserved.
//

import UIKit

//#define TimeStamp [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000]

class BodyViewController: UIViewController {

  var threshold :Float = 240.0
  var secondsThreshold :NSTimeInterval = 2.5
  var meterHeight :CGFloat = 120.0
  
  @IBOutlet weak var body             :UIImageView!
  @IBOutlet weak var muscles_abs      :UIImageView!
  @IBOutlet weak var muscles_thigh    :UIImageView!
  
  @IBOutlet weak var score1back: UIView!
  @IBOutlet weak var score2back: UIView!
  @IBOutlet weak var fbTotalView: UILabel!
  @IBOutlet weak var ssTotalView: UILabel!
  
  @IBOutlet weak var on_1: UIImageView!
  @IBOutlet weak var on_2: UIImageView!
  
  var off_1 :UIImageView = UIImageView()
  var off_2 :UIImageView = UIImageView()

  var regTimeStamp = NSDate()


  // total swipes
  var fbCount = 0
  var ssCount = 0
  
  var xreadings: [Float] = []
  var yreadings: [Float] = []
  var groupTotalsFB: [Float] = []
  var groupTotalsSS: [Float] = []
  var runningChangeX: [Float] = []
  var runningChangeY: [Float] = []
  
  var paused = false
  var evaluatingGroup = false
  var evaluatingGroupCount = 0
  
  
  override func viewDidLoad() {
    super.viewDidLoad()

    score1back.layer.cornerRadius = 8
    score2back.layer.cornerRadius = 8

    self.off_1.contentMode = UIViewContentMode.ScaleAspectFill
    self.off_1.clipsToBounds = true
    
    // place the gradient off images
    let imag :UIImage = UIImage(named: "gradient_off_30")!
    off_1.image = imag
    off_1.contentMode = UIViewContentMode.TopLeft
    off_1.clipsToBounds = true
    off_1.frame = CGRectMake(224, 275, 30, 120)
    self.view.addSubview(off_1)
    
    off_2.image = imag
    off_2.contentMode = UIViewContentMode.TopLeft
    off_2.clipsToBounds = true
    off_2.frame = CGRectMake(270, 275, 30, 120)
    self.view.addSubview(off_2)
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "notifiedOfMovement:", name: GraphViewMovementNotification, object: nil)
  }
  
  // functions for visual meter
  @IBAction func Btn1(sender: AnyObject) {
    showMovementFB()
    setMeter(off_1, amt: 5)
  }
  
  func setMeter(sender: UIImageView, amt: CGFloat) {
    println("setMeter \(sender)")
    var height :CGFloat = meterHeight * CGFloat(amt * 0.1)
    
    // amt is 0 - 10 reading
    var curFrame :CGRect = sender.frame

    println("amt: \(amt)  height: \(height)")
    curFrame = CGRect(x: curFrame.origin.x, y: curFrame.origin.y, width: curFrame.width, height: height)
    sender.frame = curFrame
    
    NSTimer.scheduledTimerWithTimeInterval(0.5, target:self, selector:"animateMeterOff", userInfo:nil, repeats: false)
    
  }
  
  // capture movement coming in
  func notifiedOfMovement(notification: NSNotification){
  
    if let id:VTSensorReading = notification.userInfo?["reading"] as? VTSensorReading {
      xreadings.append(id.x * 1000.0)
      yreadings.append(id.y * 1000.0)
      println("x: \(Int(id.x * 1000.0))    y: \(Int(id.y * 1000.0))")
    }
    
    // if paused, check again to get unpaused.
    if (paused) {
    var nowTime = NSDate()
    let timeDif :NSTimeInterval = nowTime.timeIntervalSinceDate(regTimeStamp)
      if (timeDif > secondsThreshold) {
        paused = false
      }
    } else {                // if not paused, check new readings for swipes
      newReadingCheck()
      //checkForSSSwipe()
    }
  }
  
  func newReadingCheck() {
    
    if (xreadings.endIndex > 13) {

      var biggestX :Float = xreadings[xreadings.endIndex - 1]
      var smallestX :Float = xreadings[xreadings.endIndex - 1]
      var biggestY :Float = yreadings[xreadings.endIndex - 1]
      var smallestY :Float = yreadings[xreadings.endIndex - 1]
      
      // evaluate previous 5
      for i in 2 ... 6 {
        var x :Float = xreadings[xreadings.endIndex - i]
        var y :Float = yreadings[yreadings.endIndex - i]
        if (biggestX < x) { biggestX = x; }
        if (biggestY < y) { biggestY = y; }
        if (smallestX > x) { smallestX = x; }
        if (smallestY > y) { smallestY = y; }
      }
      println("smallestX: \(Int(smallestX))   ...   y: \(Int(smallestY))")
      println("biggestX: \(Int(biggestX))   ...   y: \(Int(biggestY))")
      var difX = abs(biggestX - smallestX)
      var difY =  abs(biggestY - smallestY)
      println("xDif: \(Int(difX))   ...   yDif: \(Int(difY))")
      
      // if it's over threshold, then start an evaluation
      if (difX > threshold) {
        self.evaluatingGroup = true
        setMeter(off_1, amt: 5)
        println("FB")
        showMovementFB()
      }
      if (difY > threshold) {
        self.evaluatingGroup = true
        setMeter(off_2, amt: 5)
        println("SS")
        showMovementSS()
      }
      
      // if we're in evaluation, capture dif totals. 10 readings forward, look back with evalForSwipe()
      if (self.evaluatingGroup) {
        groupTotalsFB.append(difX)
        groupTotalsSS.append(difY)
        println("FBTotal: \(Int(difX))   ...   SSTotal: \(Int(difY))")
        evaluatingGroupCount++
        if (evaluatingGroupCount > 10) { evalForSwipe() }
      }
    }
  }
  
  func evalForSwipe() {
    
    var biggestFB :Float = 0
    var biggestSS :Float = 0
    
    for (index, value) in enumerate(groupTotalsFB) {
      if (value > biggestFB) { biggestFB = value }
    }
    
    for (index, value) in enumerate(groupTotalsSS) {
      if (value > biggestSS) { biggestSS = value }
    }
    
    
    //println("SS: \(groupTotalsSS)")
    //println("FB: \(groupTotalsFB)")
        
    println("# of FB: \(groupTotalsFB.count) SS: \(groupTotalsSS.count)")
    println("Biggest - FB: \(Int(biggestFB)) SS: \(Int(biggestSS))")
    
    if (biggestSS > biggestFB) {
      SSSwipeDetected()
      println("SS Detected.")
    } else {
      FBSwipeDetected()
      println("FB Detected.")
    }
    
    groupTotalsFB = []
    groupTotalsSS = []
    evaluatingGroup = false
    evaluatingGroupCount = 0
    
  }
  
  
  func FBSwipeDetected() {
    paused = true
    regTimeStamp = NSDate()
    updateFBTotal()
  }
  
  func SSSwipeDetected() {
    paused = true
    regTimeStamp = NSDate()
    updateSSTotal()
  }
  
  
  func updateFBTotal() {
    fbCount += 1
    fbTotalView.text = String(fbCount)
  }

  
  func updateSSTotal() {
    ssCount += 1
    ssTotalView.text = String(ssCount)
  }
  
  /* func showMovement(theImage: UIImageView) {
    animateImageViewOn(theImage)
  } */

  func showMovementFB() {
    animateImageViewOn(muscles_abs)
  }
  
  func showMovementSS() {
    animateImageViewOn(muscles_thigh)
  }
  
  func setImageAlpha(theImage: UIImageView, alpha: CGFloat) {
    theImage.alpha = alpha
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
  
  func animateMeterOff() {
    var curFrame :CGRect = off_1.frame
    curFrame = CGRect(x: curFrame.origin.x, y: curFrame.origin.y, width: curFrame.width, height:120)
    off_1.frame = curFrame
    
    /* CATransaction.begin()
    CATransaction.setAnimationDuration(0.4)
    let transition = CATransition()
    transition.type = kCATransitionFade
    off_1.layer.addAnimation(transition, forKey: kCATransition)
    CATransaction.commit()
    off_1.hidden = false */
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}


// PREVIOUS
/* 
// get total of previous 5, put in groupTotalsFB
for i in 2 ... 6 {
var i2 = i - 1

var x1 = xreadings[xreadings.endIndex - i]
var x2 = xreadings[xreadings.endIndex - i2]
var difX = abs(x1 - x2)
groupXtotal += difX

var y1 = yreadings[yreadings.endIndex - i]
var y2 = yreadings[yreadings.endIndex - i2]
var difY = abs(y1 - y2)
groupYtotal += difY
}
*/
