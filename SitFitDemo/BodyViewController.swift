//
//  MainActivityViewController.swift
//  SitFitDemo
//
//  Created by Lynn Smith on 12/12/14.
//  Copyright (c) 2014 Lynn Smith. All rights reserved.
//

import UIKit

class BodyViewController: UIViewController {
 
  // hook up shite to the .xib
  @IBOutlet weak var body             :UIImageView!
  @IBOutlet weak var muscles_abs      :UIImageView!
  @IBOutlet weak var muscles_thigh    :UIImageView!
  
  @IBOutlet weak var score1back: UIView!
  @IBOutlet weak var score2back: UIView!
  @IBOutlet weak var fbTotalView: UILabel!
  @IBOutlet weak var ssTotalView: UILabel!
  
  @IBOutlet weak var on_1: UIImageView!
  @IBOutlet weak var on_2: UIImageView!
  
  // set up vars for overlays (not in .xib)
  var meter1_overlay :UIImageView = UIImageView()
  var meter2_overlay :UIImageView = UIImageView()

  // set thresholds, pause info and counter for when evaluating
  var threshold :Int = 240
  var thresholdSensitivity = 8
  var pauseThreshold :NSTimeInterval = 2
  var paused = false
  var evaluatingGroupCount = 0
  var regTimeStamp = NSDate()
  
  // create sensor readings model
  let SR :SensorReadings = SensorReadings()

  // set up vars for current value shown on meters
  var meter1Reading :Int = 0
  var meter2Reading :Int = 0
  var meterHeight :CGFloat = 120.0
  
  // set up count of swipes, fb and ss
  var fbCount = 0
  var ssCount = 0

  
  override func viewDidLoad() {
    super.viewDidLoad()

    // style
    score1back.layer.cornerRadius = 8
    score2back.layer.cornerRadius = 8
    self.meter1_overlay.contentMode = UIViewContentMode.ScaleAspectFill
    self.meter1_overlay.clipsToBounds = true
    self.meter2_overlay.contentMode = UIViewContentMode.ScaleAspectFill
    self.meter2_overlay.clipsToBounds = true
    
    // create and place the overlay images on the meters
    let imag :UIImage = UIImage(named: "gradient_off_30")!
    meter1_overlay.image = imag
    meter1_overlay.contentMode = UIViewContentMode.TopLeft
    meter1_overlay.clipsToBounds = true
    meter1_overlay.frame = CGRectMake(224, 275, 30, 120)
    self.view.addSubview(meter1_overlay)
    
    meter2_overlay.image = imag
    meter2_overlay.contentMode = UIViewContentMode.TopLeft
    meter2_overlay.clipsToBounds = true
    meter2_overlay.frame = CGRectMake(270, 275, 30, 120)
    self.view.addSubview(meter2_overlay)
    
    // observe for movement
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "notifiedOfMovement:", name: GraphViewMovementNotification, object: nil)
  }

  
  // MARK: - Sensor reading processing
  
  func notifiedOfMovement(notification: NSNotification){

    if let id:VTSensorReading = notification.userInfo?["reading"] as? VTSensorReading {
      println("x: \(Int(id.x * 1000.0))    y: \(Int(id.y * 1000.0))")
      SR.xread = Int(id.x * 1000.0)
      SR.yread = Int(id.y * 1000.0)
    }
    
    // gap size biggest to smallest of the past 5 readings
    var difX :Int = SR.gapDifX(5)
    var difY :Int = SR.gapDifY(5)
    //println("difX: \(difX)")
    
    // do Meter things
    switch difX {
    case 0 ... 25:
      var img :UIImageView = meter1_overlay
      if (meter1Reading != 0) {
        var theTimer = NSTimer.scheduledTimerWithTimeInterval(0.3, target:self, selector:"meter1Off:", userInfo:img, repeats: false)
      }
    case 26 ... 50:
      setMeter(meter1_overlay, amt: 3)
    case 51 ... 100:
      setMeter(meter1_overlay, amt: 6)
    case 101 ... 200:
      setMeter(meter1_overlay, amt: 9)
    case 201 ... 100000:
      setMeter(meter1_overlay, amt: 10)
    default:
      break
    }
    
    
    /* if (difX > 50) {
    //showMovementFB()
    //setMeter(off_1, amt: 5)
    //showMovementFB()
    }
    
    if (difX > 50) {
    //showMovementFB()
    //setMeter(off_1, amt: 5)
    //showMovementFB()
    }
    
    if (difY > 50) {
    setMeter(meter2_overlay, amt: 8)
    showMovementSS()
    } */
    
    
    // if paused, check if we need to unpause
    if (paused) {
    var nowTime = NSDate()
    let timeDif :NSTimeInterval = nowTime.timeIntervalSinceDate(regTimeStamp)
      if (timeDif > pauseThreshold) {
        paused = false
      }
    } else {
      
      // over threshold? Start swipe evaluation
      if (difX > threshold || difY > threshold) {
        evaluatingGroupCount = 1
      }
      
      // 5 readings later, trigger evalForSwipe() to mark a FB (x type) or SS (y type) swipe
      if (evaluatingGroupCount != 0) {
        evaluatingGroupCount++
        if (evaluatingGroupCount > 5) { evalForSwipe() }
      }
      
    }
  }
  
  func evalForSwipe() {
    
    var biggestGapX = SR.gapDifX(thresholdSensitivity)
    var biggestGapY = SR.gapDifY(thresholdSensitivity)

    //println("Biggest - X: \(Int(biggestGapX)) Y: \(Int(biggestGapY))")
    
    if (biggestGapY > biggestGapX) {
      SSSwipeDetected()
      println("   *****   SS Detected.   *****")
    } else {
      FBSwipeDetected()
      println("   *****   FB Detected.   *****")
    }
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
  
  // MARK: - Body Animation
  
  func showMovementFB() {
    setImageAlpha(muscles_abs, amt: 0.5)
    NSTimer.scheduledTimerWithTimeInterval(1.0, target:self, selector:"setAbsOff", userInfo:nil, repeats: false)
  }
  
  func showMovementSS() {
    setImageAlpha(muscles_thigh, amt: 0.5)
    NSTimer.scheduledTimerWithTimeInterval(1.0, target:self, selector:"setThighsOff", userInfo:nil, repeats: false)
  }
  
  func setImageAlpha(theImage: UIImageView, amt: CGFloat) {
    theImage.alpha = amt
  }
  
  func setAbsOff() {
    muscles_abs.alpha = 0
  }

  func setThighsOff() {
    muscles_thigh.alpha = 0
  }
  
  /*func animateImageViewOn(theImage: UIImageView) {
     CATransaction.begin()
    CATransaction.setAnimationDuration(0.2)
    let transition = CATransition()
    transition.type = kCATransitionFade
    
    theImage.layer.addAnimation(transition, forKey: kCATransition)
   
    /* CATransaction.setCompletionBlock {
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.8 * NSTimeInterval(NSEC_PER_SEC))), dispatch_get_main_queue()) {
        self.animateImageViewOff(theImage)
      }
    } */
    
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
  } */
  
  
  /* @IBAction func Btn1(sender: AnyObject) {
    //showMovementFB()
    //setMeter(off_1, amt: 5)
  } */
  
  func setMeter(sender: UIImageView, amt: CGFloat) {
    meter1Reading = Int(amt)
    println("meter1set: \(amt)")
    var height :CGFloat = meterHeight * CGFloat(amt * 0.1)
    var curFrame :CGRect = sender.frame
    //println("Set Meter: amt: \(amt)  height: \(height)")
    curFrame = CGRect(x: curFrame.origin.x, y: curFrame.origin.y, width: curFrame.width, height: height)
    sender.frame = curFrame
    //var theTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target:self, selector:"meterOff:", userInfo:sender, repeats: true)
  }
  
  func meter1Off(val :NSTimer?) {
    meter1Reading = 0
    println("meter1set: 0 - FROM OFF")
    var img :UIImageView = val?.userInfo as UIImageView
    var curFrame :CGRect = img.frame
    curFrame = CGRect(x: curFrame.origin.x, y: curFrame.origin.y, width: curFrame.width, height:120)
    img.frame = curFrame
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
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
