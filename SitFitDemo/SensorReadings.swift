//
//  SensorReadings.swift
//  SitFitDemo
//
//  Created by Lynn Smith on 1/13/15.
//  Copyright (c) 2015 Lynn Smith. All rights reserved.
//

import Foundation


class SensorReadings {
  
  // keeps last 20 values
  var xreadings: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
  var yreadings: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
  
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
      //println("Past X: \(i): \(x)")
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
      //println("Past Y: \(i): \(y)")
    }
    return abs(biggestY - smallestY)
  }
  
  
}