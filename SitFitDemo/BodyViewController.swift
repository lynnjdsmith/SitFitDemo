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
  var threshold :Int = 350
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

    // put values into sensor reading model
    if let id:VTSensorReading = notification.userInfo?["reading"] as? VTSensorReading {
      //println("x: \(Int(id.x * 1000.0))    y: \(Int(id.y * 1000.0))")
      SR.xread = Int(id.x * 1000.0)
      SR.yread = Int(id.y * 1000.0)
      setMeter(meter2_overlay, amt: 0)  // turn on meters a little bit
      setMeter(meter1_overlay, amt: 0)
    }
    
    // find gap size (biggest to smallest) of the past 5 readings
    var difX :Int = SR.gapDifX(5)
    var difY :Int = SR.gapDifY(5)
    
    //println("difX: \(difX)")
    // do Meter things
    switch difX {
    case threshold  ... (Int(CGFloat(threshold) * 1.5)):
      if (meter1Reading < 3) { setMeter(meter1_overlay, amt: 3) }
    case (Int(CGFloat(threshold) * 1.5)) ... (Int(CGFloat(threshold) * 2)):
      if (meter1Reading < 6) { setMeter(meter1_overlay, amt: 6) }
    case (Int(CGFloat(threshold) * 2)) ... (Int(CGFloat(threshold) * 2.5)):
      if (meter1Reading < 9) { setMeter(meter1_overlay, amt: 9) }
    case (Int(CGFloat(threshold) * 2.5)) ... (Int(CGFloat(threshold) * 3)):
      setMeter(meter1_overlay, amt: 10)
    default:
      break
    }

    /* switch difY {
    case threshold  ... (Int(CGFloat(threshold) * 1.5)):
      if (meter1Reading < 3) { setMeter(meter2_overlay, amt: 3) }
    case (Int(CGFloat(threshold) * 1.5)) ... (Int(CGFloat(threshold) * 2)):
      if (meter1Reading < 6) { setMeter(meter2_overlay, amt: 6) }
    case (Int(CGFloat(threshold) * 2)) ... (Int(CGFloat(threshold) * 2.5)):
      if (meter1Reading < 9) { setMeter(meter2_overlay, amt: 9) }
    case (Int(CGFloat(threshold) * 2.5)) ... (Int(CGFloat(threshold) * 3)):
      setMeter(meter1_overlay, amt: 10)
    default:
      break
    } */
    
    // if paused, check if we need to unpause
    if (paused) {
    var nowTime = NSDate()
    let timeDif :NSTimeInterval = nowTime.timeIntervalSinceDate(regTimeStamp)
      if (timeDif > pauseThreshold) {
        paused = false
      }
    } else {
      
      // was the reading over threshold? Start swipe evaluation
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
  
  // amt = 1 to 10
  func setMeter(sender: UIImageView, amt: CGFloat) {
    meter1Reading = Int(amt)
    //println("meterset: \(amt)")
    var height :CGFloat = meterHeight - (meterHeight * CGFloat(amt * 0.1))
    if (height > (meterHeight - 10)) { height = meterHeight - 10 } // want to leave it on a bit
    var curFrame :CGRect = sender.frame
    //println("Set Meter: amt: \(amt)  height: \(height)")
    curFrame = CGRect(x: curFrame.origin.x, y: curFrame.origin.y, width: curFrame.width, height: height)
    sender.frame = curFrame
    if (meter1Reading > 0) {
      meter1Reading = meter1Reading - 1
      //println("meter1Down: \(meter1Reading)")
      var theTimer = NSTimer.scheduledTimerWithTimeInterval(0.6, target:self, selector:"meter1Down:", userInfo:sender, repeats: false)
    }
  }
  
  func meter1Down(val :NSTimer?) {
      var img :UIImageView = val?.userInfo as UIImageView
      setMeter(img, amt: CGFloat(meter1Reading))
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
  

  
 /*  func meter1Off(val :NSTimer?) {
    meter1Reading = 0
    println("meter1set: 0 - FROM OFF")
    var img :UIImageView = val?.userInfo as UIImageView
    var curFrame :CGRect = img.frame
    curFrame = CGRect(x: curFrame.origin.x, y: curFrame.origin.y, width: curFrame.width, height:120)
    img.frame = curFrame
  }*/


  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}
