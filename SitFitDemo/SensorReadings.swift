//
//  SensorReadings.swift
//  SitFitDemo
//
//  Created by Lynn Smith on 1/13/15.
//  Copyright (c) 2015 Lynn Smith. All rights reserved.
//

import Foundation


let nAvg: Int = 100  //sets the number of readings kept in the running average -CJW
let nPeakPersist: Int = 350  //sets the persistence or fade period for peak value detection+display -CJW


class SensorReadings {
  
  // keeps last 20 values
  var xreadings: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
  var yreadings: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
  var numOfReadings :Int = 0
    
    
    ///////////////New shite from CJW////////////////////////
    
    var xFloats = [CGFloat](count: nAvg, repeatedValue: 0.0)
    var yFloats = [CGFloat](count: nAvg, repeatedValue: 0.0)

    var xRunAvg: CGFloat = 0;
    var yRunAvg: CGFloat = 0;
    
    var xPeak: CGFloat = 0;
    var yPeak: CGFloat = 0;

    var xPeakPersistCount: Int = nPeakPersist
    var yPeakPersistCount: Int = nPeakPersist
    
    //update running average and current peak values for x, keep track of peak value persist/fade
    func updateX(xIn: CGFloat) {
        xFloats.removeAtIndex(0)
        xFloats.append(xIn)
        xRunAvg = 0
        for xval in xFloats {
            xRunAvg = xRunAvg + xval
        }
        xRunAvg = abs(xRunAvg / CGFloat(nAvg));
        
        if (abs(xIn) > xPeak) {
            xPeak = abs(xIn)
            xPeakPersistCount = nPeakPersist   //reset persistence timer since we have a new peak value
        }
        else {
            if (xPeakPersistCount>0) {         //or decrement counter since we don't have a new peak
                xPeakPersistCount--
                xPeak = xPeak * (CGFloat(xPeakPersistCount)/CGFloat(nPeakPersist))   //make "peak" value fade as it gets old
            }
        }
    }
    
    //update running average and current peak values for y, keep track of peak value persist/fade
    //I know I shouldn't have to type all this again for y. There's a way better OOP way.
    func updateY(yIn: CGFloat) {
        yFloats.removeAtIndex(0)
        yFloats.append(yIn)
        yRunAvg = 0
        for yval in yFloats {
            yRunAvg = yRunAvg + yval
        }
        yRunAvg = abs(yRunAvg / CGFloat(nAvg))
        
        
        if (abs(yIn) > yPeak) {
            yPeak = abs(yIn);
            yPeakPersistCount = nPeakPersist;
        }
        else {
            if (yPeakPersistCount>0) {
                yPeakPersistCount--
                yPeak =  yPeak * (CGFloat(yPeakPersistCount)/CGFloat(nPeakPersist))
            }
        }
        
    }
    
    /////////////End new shite CJW//////////////////////////////
    
  
  var xread :Int {
    get {
      return 8 //never used
    }
    set(newX) {
      xreadings.removeAtIndex(0)
      xreadings.append(newX)
    }
  }
  
    
  var yread :Int {
    get {
      return 8 //never used
    }
    set(newY) {
      yreadings.removeAtIndex(0)
      yreadings.append(newY)
    }
  }

  
  // This is the gap between the highest and lowest of the last 'pastnum' readings - X
  func gapDifX(pastnum :Int) -> Int  {
    var biggestX :Int = xreadings[xreadings.endIndex - 1]
    var smallestX :Int = xreadings[xreadings.endIndex - 1]
    
    for i in 2 ... pastnum + 1 {
      var x :Int = xreadings[xreadings.endIndex - i]
      if (biggestX < x) { biggestX = x; }
      if (smallestX > x) { smallestX = x; }
    }
    return abs(biggestX - smallestX)
  }
  
    
  // This is the gap between the highest and lowest of the last 'pastnum' readings - Y
  func gapDifY(pastnum :Int) -> Int  {
    var biggestY :Int = yreadings[yreadings.endIndex - 1]
    var smallestY :Int = yreadings[yreadings.endIndex - 1]
    
    for i in 2 ... pastnum + 1 {
      var y :Int = yreadings[yreadings.endIndex - i]
      if (biggestY < y) { biggestY = y; }
      if (smallestY > y) { smallestY = y; }
    }
    return abs(biggestY - smallestY)
  }
  
}