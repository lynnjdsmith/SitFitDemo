//
//  MainActivityViewController.swift
//  SitFitDemo
//
//  Created by Lynn Smith on 12/12/14.
//  Copyright (c) 2014 Lynn Smith. All rights reserved.


import UIKit

class BodyViewController: UIViewController {
 
  @IBOutlet weak var body             :UIImageView!
  @IBOutlet weak var muscles_abs      :UIImageView!
  @IBOutlet weak var muscles_thigh    :UIImageView!
    
  @IBOutlet weak var muscles_abs1      :UIImageView!
  @IBOutlet weak var muscles_abs2      :UIImageView!
  @IBOutlet weak var muscles_abs3      :UIImageView!
  @IBOutlet weak var muscles_abs4      :UIImageView!
  @IBOutlet weak var muscles_legs_calf_inner      :UIImageView!
  @IBOutlet weak var muscles_legs_calf_outer      :UIImageView!
  @IBOutlet weak var muscles_legs_sides      :UIImageView!
  
  @IBOutlet weak var score1back       :UIView!
  @IBOutlet weak var score2back: UIView!
  @IBOutlet weak var fbTotalView: UILabel!
  @IBOutlet weak var ssTotalView: UILabel!
  @IBOutlet weak var totalEffort: UILabel!
  
  @IBOutlet weak var on_1: UIImageView!
  @IBOutlet weak var on_2: UIImageView!
  @IBOutlet weak var slider1: UISlider!
  @IBOutlet weak var slider2: UISlider!
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        var currentValue = sender.value
        userScaler = CGFloat(currentValue / 5)
    }

  var userScaler: CGFloat = 1   //set initial value for user setting of slider
    
  var ssMovementFactor : CGFloat = 1.25  //overweight the side to side movement when deciding to increment FB or SS counters
    
  var pauseThreshold :NSTimeInterval = 1  // pause for this long after incrementing movement counter
   
  var FBthreshold : CGFloat = 2.8    //threshold for front-to-back movement peak detection
  var SSthreshold : CGFloat = 2.5    //threshold for side-to-side movement peak detection
    
  // set starting empty values
  var paused = false
  var evaluatingCount = 0
  var regTimeStamp = NSDate()
  var fbCount :Int = 0
  var ssCount :Int = 0
  var teCount :CGFloat = 0
  
  // set up vars for current value shown on meters     
  var meter1Reading :Int = 0
  var meter2Reading :Int = 0
  
  // create sensor readings model
  let SR :SensorReadings = SensorReadings()
  let sr :SharedReading = SharedReading()
  
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
    
    SharedReading.sharedManager()
}
    
    
// MARK: - Sensor reading processing
  
  func notifiedOfMovement(notification: NSNotification){

    var xin: CGFloat = CGFloat(sr.getX())
    var yin: CGFloat = CGFloat(sr.getY())
    
    SR.updateX(xin)
    SR.updateY(yin)
    
    lightAbs(SR.xPeak * userScaler, y: SR.yPeak * userScaler)
    lightThighs(SR.xPeak * userScaler, y: SR.yPeak * userScaler)
    
    setMeter(meter1_overlay, amt: (SR.xPeakNoFade * 4 * userScaler))
    setMeter(meter2_overlay, amt: (SR.yPeakNoFade * 4 * userScaler))
    
    println("UserScaler \(userScaler)")
    
   // println("\nAbs alpha: \(muscles_abs.alpha)   Thighs alpha: \(muscles_thigh.alpha)")
    
    println("\nFBmeter: \(SR.xPeak * 4 * userScaler)   SSmeter: \(SR.yPeak * 4 * userScaler)")
    
    SR.xread = Int(xin * 1000.0 * userScaler)
    SR.yread = Int(yin * 1000.0 * userScaler)
    
    if (paused) {
        var nowTime = NSDate()
        let timeDif :NSTimeInterval = nowTime.timeIntervalSinceDate(regTimeStamp)
        if (timeDif > pauseThreshold) {
            paused = false
        }
    } else {
        
        if ((SR.xPeak * 4 * userScaler) > FBthreshold || (SR.yPeak * 4 * userScaler) > SSthreshold) {
            evalForSwipe()
        }
    }
    
  }
 

  func evalForSwipe() {
    
    var currentPeakX = (SR.xPeak * 4 * userScaler)
    var currentPeakY = (SR.yPeak * 4 * userScaler)
        
    if ((currentPeakY * ssMovementFactor) > currentPeakX) {
      SSSwipeDetected()
    } else {
      FBSwipeDetected()
    }
    evaluatingCount = 0
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
    updateTotalEffort()
  }

  
  func updateSSTotal() {
    ssCount += 1
    ssTotalView.text = String(ssCount)
    updateTotalEffort()
  }
  
  func updateTotalEffort() {
    teCount = teCount + (1/(userScaler+0.01))  //add to current total effort count according to current level of difficulty
    totalEffort.text = String(Int(teCount))
  }
  
// MARK: - Body Animation
    
    func lightAbs(x: CGFloat, y: CGFloat) {
        muscles_abs1.alpha =  0.7*(1*x + 0.25*y)
        muscles_abs2.alpha =  0.8*(1*x + 0.25*y)
        muscles_abs3.alpha =  0.9*(1*x + 0.25*y)
        muscles_abs4.alpha =  1.0*(1*x + 0.25*y)
        //chose these coefficients by trial and error to try to keep the alpha less
        //than 1 most of the time... don't want it to saturate all the time, want the movement's gradation to be apparent
        //and with the slider2 the user can change the scaling of x and y from 0 to x2 it's original value
    }
    
    
    func lightThighs(x: CGFloat, y: CGFloat) {
        muscles_thigh.alpha = 1*y + 0.25*x   //ditto.
        muscles_legs_calf_inner.alpha = 0.6*(1*y + 0.1*x)
        muscles_legs_calf_outer.alpha = 0.6*(1*y + 0.1*x)
        muscles_legs_sides.alpha = 0.6*y
    }

    
    func setMeter(sender: UIImageView, amt: CGFloat) {
        meter1Reading = Int(amt)
        var height :CGFloat = 120 - (amt * 50)
        if (height < 0) {
            height = 0
        }
        var curFrame :CGRect = sender.frame
        curFrame = CGRect(x: curFrame.origin.x, y: curFrame.origin.y, width: curFrame.width, height: height)
        sender.frame = curFrame
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
    
}
