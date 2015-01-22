//
//  MainActivityViewController.swift
//  SitFitDemo
//
//  Created by Lynn Smith on 12/12/14.
//  Copyright (c) 2014 Lynn Smith. All rights reserved.
//
// improvement todos - 
// an area calculation rather than detecting peaks.
// for y, do we need to add the z adjustment to give that a boost? not sure why y isn't reading as fully.

import UIKit

class BodyViewController: UIViewController {
 
  // hook up shite to the .xib
  @IBOutlet weak var body             :UIImageView!
  @IBOutlet weak var muscles_abs      :UIImageView!
  @IBOutlet weak var muscles_thigh    :UIImageView!
  @IBOutlet weak var score1back       :UIView!
  @IBOutlet weak var score2back: UIView!
  @IBOutlet weak var fbTotalView: UILabel!
  @IBOutlet weak var ssTotalView: UILabel!
  @IBOutlet weak var on_1: UIImageView!
  @IBOutlet weak var on_2: UIImageView!
  @IBOutlet weak var slider1: UISlider!
  @IBOutlet weak var slider2: UISlider!
  
  // ** thresholds **
  
  // when we see a big movement by looking back n readings for big gap, start evaluaing to detect swipe type
  var threshold   :Int = 320       // threshold for how big the size of the movement size must be to trigger a recorded movement
  var lookThisFarBack = 5        // each single reading that comes in, go back this # of readings and look at biggest / smallest readings
  var evaluationLength = 5       // evaluate for this many subsequent redings
  
  // z sway seems to affect the X readings, but not Y.    whY? I don't know. but, let's adjust.
  var zThreshold  :Int = 100          // how big of a z dif reading to care about
  var zModifier   :CGFloat = 1.9          // how much to adjust X for Z peaking out ?
  
  // pause for this long after detecting swipe
  var pauseThreshold :NSTimeInterval = 2
  
  
  // set starting empty values
  var paused = false
  var evaluatingCount = 0
  var regTimeStamp = NSDate()
  var fbCount = 0
  var ssCount = 0
  
  // set up vars for current value shown on meters     
  var meter1Reading :Int = 0
  var meter2Reading :Int = 0
  
  // create sensor readings model
  let SR :SensorReadings = SensorReadings()
  
  // set up vars for overlays (not in .xib)
  var meter1_overlay :UIImageView = UIImageView()
  var meter2_overlay :UIImageView = UIImageView()
  var meterHeight :CGFloat = 120.0 // this is the height of the image in the .xib, we need it in a var for calculations below.
  
  
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

  
 /* LS - this breaks things. Removing for now.
  @IBAction func moveSlider1(sender: AnyObject) {
    println("here! \(slider1.value)")
  } */
  
  
  // MARK: - Sensor reading processing
  
  func notifiedOfMovement(notification: NSNotification){

    var currentZ :Int = 0
    
    // put values into sensor reading model
    if let id:VTSensorReading = notification.userInfo?["reading"] as? VTSensorReading {
      println("\nx: \(Int(id.x * 1000.0))   y: \(Int(id.y * 1000.0)) z: \(Int(id.z * 1000.0))")     // ***  see the x and y coming in. ***
      SR.xread = Int(id.x * 1000.0)
      SR.yread = Int(id.y * 1000.0)
      SR.zread = Int(id.z * 1000.0)
      setMeter(meter2_overlay, amt: 0)  // turn on meters a little bit
      setMeter(meter1_overlay, amt: 0)
      currentZ = Int(id.z * 1000.0)
    }
    
    // find gap size (biggest to smallest) of the past 5 readings
    var difX :Int = SR.gapDifX(lookThisFarBack)
    var difY :Int = SR.gapDifY(lookThisFarBack)
    println("difX: \(difX)")    // see the gap for X, past 5 readings
    
    // modify difX if Z is acting up.
    var zAvg :Int = SR.zAvg
    println("zAvg: \(zAvg)")
    var zGap :Int = abs(zAvg - currentZ)
    if (zGap > zThreshold) {
      difX = difX - Int(CGFloat(zGap) * zModifier);
      println("modified by: \(Int(CGFloat(zGap) * zModifier)). currentZ = \(currentZ)")
    }
    println("difX: \(difX)")    // see the gap for X, past 5 readings
    
    // do Meter things
    switch difX {
    case threshold  ... (Int(CGFloat(threshold) * 1.5)):
      if (meter1Reading < 3) { setMeter(meter1_overlay, amt: 3) }
    case (Int(CGFloat(threshold) * 1.5)) ... (Int(CGFloat(threshold) * 1.75)):
      if (meter1Reading < 6) { setMeter(meter1_overlay, amt: 5) }
    case (Int(CGFloat(threshold) * 1.75)) ... (Int(CGFloat(threshold) * 2)):
      if (meter1Reading < 9) { setMeter(meter1_overlay, amt: 7) }
    case (Int(CGFloat(threshold) * 2)) ... (Int(CGFloat(threshold) * 4)):
      setMeter(meter1_overlay, amt: 10)
    default:
      break
    }

    switch difY {
    case threshold  ... (Int(CGFloat(threshold) * 1.5)):
      if (meter2Reading < 3) { setMeter(meter2_overlay, amt: 3) }
    case (Int(CGFloat(threshold) * 1.5)) ... (Int(CGFloat(threshold) * 1.75)):
      if (meter2Reading < 6) { setMeter(meter2_overlay, amt: 5) }
    case (Int(CGFloat(threshold) * 1.75)) ... (Int(CGFloat(threshold) * 2)):
      if (meter2Reading < 9) { setMeter(meter2_overlay, amt: 7) }
    case (Int(CGFloat(threshold) * 2)) ... (Int(CGFloat(threshold) * 4)):
      setMeter2(meter2_overlay, amt: 10)
    default:
      break
    }
    
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
        evaluatingCount = 1
        bodyStartLightingUp()
      }
      
      // n readings later, trigger evalForSwipe() to mark a FB (x type) or SS (y type) swipe
      if (evaluatingCount != 0) {
        evaluatingCount++
        if (evaluatingCount > evaluationLength) { evalForSwipe() }
      }
      
    }
  }
  
  func evalForSwipe() {
    
    // we want to check for the biggest gap (peak) in the beginning of the movement.
    var biggestGapX = SR.gapDifX(lookThisFarBack + Int(CGFloat(evaluationLength) * 0.5))
    var biggestGapY = SR.gapDifY(lookThisFarBack + Int(CGFloat(evaluationLength) * 0.5))

    //println("Biggest - X: \(Int(biggestGapX)) Y: \(Int(biggestGapY))")
    
    if (biggestGapY > biggestGapX) {
      SSSwipeDetected()
      println("   *****   SS Detected.   *****")
    } else {
      FBSwipeDetected()
      println("   *****   FB Detected.   *****")
    }
    evaluatingCount = 0
  }
  
  
  func FBSwipeDetected() {
    paused = true
    regTimeStamp = NSDate()
    showBodyFwdMovement()
    updateFBTotal()
  }
  
  func SSSwipeDetected() {
    paused = true
    regTimeStamp = NSDate()
    showBodySideMovement()
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
  
  // this is the start of when we're evaluating - to reduce lag.
  func bodyStartLightingUp() {
    CATransaction.begin()
    CATransaction.setAnimationDuration(0.2)
    let transition = CATransition()
    transition.type = kCATransitionFade
    muscles_abs.alpha = 0.25
    muscles_thigh.alpha = 0.25
    muscles_abs.layer.addAnimation(transition, forKey: kCATransition)
    muscles_thigh.layer.addAnimation(transition, forKey: kCATransition)
    CATransaction.commit()
  }
  
  func showBodyFwdMovement() {
    //setImageAlpha(muscles_abs, amt: 0.8)
    //setImageAlpha(muscles_thigh, amt: 0.2)
    
    CATransaction.begin()
    CATransaction.setAnimationDuration(0.2)
    let transition = CATransition()
    transition.type = kCATransitionFade
    muscles_abs.alpha = 0.8
    muscles_thigh.alpha = 0.2
    muscles_abs.layer.addAnimation(transition, forKey: kCATransition)
    muscles_thigh.layer.addAnimation(transition, forKey: kCATransition)
    CATransaction.commit()
    
    NSTimer.scheduledTimerWithTimeInterval(1.0, target:self, selector:"bodyOff", userInfo:nil, repeats: false)
  }
  
  func showBodySideMovement() {
    //setImageAlpha(muscles_abs, amt: 0.2)
    //setImageAlpha(muscles_thigh, amt: 0.8)
    
    CATransaction.begin()
    CATransaction.setAnimationDuration(0.2)
    let transition = CATransition()
    transition.type = kCATransitionFade
    muscles_abs.alpha = 0.2
    muscles_thigh.alpha = 0.8
    muscles_abs.layer.addAnimation(transition, forKey: kCATransition)
    muscles_thigh.layer.addAnimation(transition, forKey: kCATransition)
    CATransaction.commit()
    
    NSTimer.scheduledTimerWithTimeInterval(1.0, target:self, selector:"bodyOff", userInfo:nil, repeats: false)
  }
  
  func setImageAlpha(theImage: UIImageView, amt: CGFloat) {
    theImage.alpha = amt
  }
  
  func bodyOff() {
    
    CATransaction.begin()
    CATransaction.setAnimationDuration(0.2)
    let transition = CATransition()
    transition.type = kCATransitionFade
    muscles_thigh.alpha = 0
    muscles_abs.alpha = 0
    muscles_thigh.layer.addAnimation(transition, forKey: kCATransition)
    muscles_abs.layer.addAnimation(transition, forKey: kCATransition)
    CATransaction.commit()
    
    //muscles_thigh.alpha = 0
    //muscles_abs.alpha = 0
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

  
  func setMeter2(sender: UIImageView, amt: CGFloat) {
    meter2Reading = Int(amt)
    //println("meterset: \(amt)")
    var height :CGFloat = meterHeight - (meterHeight * CGFloat(amt * 0.1))
    if (height > (meterHeight - 10)) { height = meterHeight - 10 } // want to leave it on a bit
    var curFrame :CGRect = sender.frame
    //println("Set Meter: amt: \(amt)  height: \(height)")
    curFrame = CGRect(x: curFrame.origin.x, y: curFrame.origin.y, width: curFrame.width, height: height)
    sender.frame = curFrame
    if (meter2Reading > 0) {
      meter2Reading = meter2Reading - 1
      //println("meter1Down: \(meter1Reading)")
      var theTimer = NSTimer.scheduledTimerWithTimeInterval(0.6, target:self, selector:"meter1Down:", userInfo:sender, repeats: false)
    }
  }
  
  func meter1Down(val :NSTimer?) {
      var img :UIImageView = val?.userInfo as UIImageView
      setMeter(img, amt: CGFloat(meter1Reading))
  }
  
  func meter2Down(val :NSTimer?) {
    var img :UIImageView = val?.userInfo as UIImageView
    setMeter(img, amt: CGFloat(meter2Reading))
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
