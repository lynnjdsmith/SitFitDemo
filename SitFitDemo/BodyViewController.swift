//
//  MainActivityViewController.swift
//  SitFitDemo
//
//  Created by Lynn Smith on 12/12/14.
//  Copyright (c) 2014 Lynn Smith. All rights reserved.
//
//  add new muscle groups and separate abs
//  possible new color for muscle lighting
//  investigate lag a little more... might be inherent in BLE, but it seems like the Node+ motion app has very little lag on the "orientation stream" view, although I think it's got the same lag in "raw stream" view.  weird.  I've pretty much ruled out some other possible causes of lag, such as using the notification center.  I wonder if the animation of the Orientation Stream view makes it faster than whatever methods are used to draw the Raw Stream graphs....


import UIKit

class BodyViewController: UIViewController {
 
  // hook up shite to the .xib
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
  @IBOutlet weak var on_1: UIImageView!
  @IBOutlet weak var on_2: UIImageView!
  @IBOutlet weak var slider1: UISlider!
  @IBOutlet weak var slider2: UISlider!
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        var currentValue = sender.value
        userScaler = CGFloat(currentValue / 5)    //    println("Slider \(slider2.value)")
    }

  var userScaler: CGFloat = 1
    
  // when we see a big movement by looking back n readings for big gap, start evaluaing to detect swipe type
  var Xthreshold  :Int = 320       // threshold for how big the size of the movement size must be to trigger a recorded movement
  var Ythreshold  :Int = 220
    
  var lookThisFarBack = 5        // each single reading that comes in, go back this # of readings and look at biggest / smallest readings
  var evaluationLength = 5       // evaluate for this many subsequent redings
  
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
    
  let sr : SharedReading = SharedReading()
  
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
    

/*  I tried using BodyView as the node delegate to see if it helps eliminate lag... no dice... lag still was there
    
func nodeDeviceDidUpdateAccReading(device: VTNodeDevice, withReading reading:VTSensorReading) {
    
    SR.updateX(CGFloat(reading.x * userScaler))
    SR.updateY(CGFloat(reading.y * userScaler))
    lightAbs(SR.xPeak, y: SR.yPeak)
    lightThighs(SR.xPeak, y: SR.yPeak)
    setMeter(meter1_overlay, amt: (SR.xRunAvg*10))
    setMeter(meter2_overlay, amt: (SR.yRunAvg*10))
    
    println("UserScaler \(userScaler)")
    
    println("\nAbs alpha: \(muscles_abs.alpha)   Thighs alpha: \(muscles_thigh.alpha)")
    
        SR.xread = Int(reading.x * 1000.0)
        SR.yread = Int(reading.y * 1000.0)
        SR.zread = Int(reading.z * 1000.0)
    
        var difX :Int = SR.gapDifX(lookThisFarBack)
        var difY :Int = SR.gapDifY(lookThisFarBack)
        
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
            }
            
            // n readings later, trigger evalForSwipe() to mark a FB (x type) or SS (y type) swipe
            if (evaluatingCount != 0) {
                evaluatingCount++
                if (evaluatingCount > evaluationLength) { evalForSwipe() }
            }
            
        }
        
    }
 */
    
    
// MARK: - Sensor reading processing
  
  func notifiedOfMovement(notification: NSNotification){

  // VTNodeManager.getInstance().selectedNodeDevice.delegate = self;   //goofy place to put this, but it works
    //but of course, it breaks the Motion Stream, by stealing the NodeDevice delegate, I suppose
    //and it didn't fix the lag :(
    
    var xin: CGFloat = CGFloat(sr.getX())
    var yin: CGFloat = CGFloat(sr.getY())
    
    SR.updateX(xin)
    SR.updateY(yin)
    
    lightAbs(SR.xPeak * userScaler, y: SR.yPeak * userScaler)
    lightThighs(SR.xPeak * userScaler, y: SR.yPeak * userScaler)
    
    setMeter(meter1_overlay, amt: (SR.xPeakNoFade * 4 * userScaler))
    setMeter(meter2_overlay, amt: (SR.yPeakNoFade * 4 * userScaler))
    
    println("UserScaler \(userScaler)")
    
    println("\nAbs alpha: \(muscles_abs.alpha)   Thighs alpha: \(muscles_thigh.alpha)")
    
    SR.xread = Int(xin * 1000.0 * userScaler)  //this might have to be adjusted a bit -CJW
    SR.yread = Int(yin * 1000.0 * userScaler)
    
    var difX :Int = SR.gapDifX(lookThisFarBack)
    var difY :Int = SR.gapDifY(lookThisFarBack)  //changed to make side-side shuffles register a bit more easily
    
    if (paused) {
        var nowTime = NSDate()
        let timeDif :NSTimeInterval = nowTime.timeIntervalSinceDate(regTimeStamp)
        if (timeDif > pauseThreshold) {
            paused = false
        }
    } else {
        
        // was the reading over threshold? Start swipe evaluation
        if (difX > Xthreshold || difY > Ythreshold) {
            evaluatingCount = 1
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
    
    if (biggestGapY > biggestGapX) {
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
  }

  
  func updateSSTotal() {
    ssCount += 1
    ssTotalView.text = String(ssCount)
  }
  
    
// MARK: - Body Animation
    
    func lightAbs(x: CGFloat, y: CGFloat) {
        muscles_abs1.alpha =  0.7*(1*x + 0.25*y)
        muscles_abs2.alpha =  0.8*(1*x + 0.25*y)
        muscles_abs3.alpha =  0.9*(1*x + 0.25*y)
        muscles_abs4.alpha =  1.0*(1*x + 0.25*y)
        //I chose these coefficients by trial and error to try to keep the alpha less
        //than 1 most of the time... don't want it to saturate all the time, want the movement's gradation to be apparent
        //with the slider2 the user can change the scaling of x and y from 0 to x2 it's original value, also
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
