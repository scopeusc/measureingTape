//
//  ViewController.swift
//  measuering_tape
//
//  Created by Zachary Denham on 7/3/16.
//  Copyright © 2016 elated. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    var motionManager: CMMotionManager!
    var moveData: [[Double]] = []
    var distance: Double = 0.0
    var time: Double = 0.0
    var frequency = 0.01
    
    override func viewDidLoad() {
        super.viewDidLoad()
        motionManager = CMMotionManager()
        motionManager.accelerometerUpdateInterval = frequency // to be changed later
        motionManager.gyroUpdateInterval = frequency
    }
    
    @IBAction func endMeasureing(sender: AnyObject) {
        motionManager.stopAccelerometerUpdates()
        if(!moveData.isEmpty){
            processData()
            moveData.removeAll()
        }
        distance = 0
        time = 0.0
    }
    @IBAction func startMeasuring(sender: AnyObject) {
        
        meters.text = "-------"
        english.text = "-------"
        
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!) { (accelerometerData: CMAccelerometerData?, NSError) -> Void in
        
            self.outputAcceleration(accelerometerData!.acceleration)
            if(NSError != nil) {
                print("\(NSError)")
            }
        }
        
//        motionManager.startGyroUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: { (gyroData: CMGyroData?, NSError) -> Void in
//            self.outputGyro(gyroData!.rotationRate)
//            if (NSError != nil){
//                print("\(NSError)")
//            }
//            
//            
//        })
    }
    
    @IBOutlet weak var z: UILabel!
    @IBOutlet weak var y: UILabel!
    @IBOutlet weak var x: UILabel!
    @IBOutlet weak var meters: UILabel!
    @IBOutlet weak var ui_time: UILabel!
    @IBOutlet weak var english: UILabel!
    
    func outputAcceleration(acceleration: CMAcceleration) {
        let temp = roundArray([acceleration.x, acceleration.y, acceleration.z])
        moveData.append(temp)
        x.text = String(temp[0])
        y.text = String(temp[1])
        z.text = String(temp[2])
        time+=frequency
        ui_time.text = String(time)
    }
    
    func roundArray(myArray: [Double]) -> [Double] {
        let a = Double(round(10*myArray[0])/10)
        let b = Double(round(10*myArray[1])/10)
        let c = Double(round(10*myArray[2])/10)
        return [a, b, c]
    }
    
    func outputGyro(gyro: CMRotationRate){
        
    }
    
    func processData () {
        let multiplier = frequency * 9.8
        let startData = moveData[1]
        var d_0 = [0.0, 0.0, 0.0]
        var v_0 = [0.0, 0.0, 0.0]
        
        for acceleration in moveData {
            v_0[0] += multiplier*acceleration[0] - multiplier*startData[0]
            v_0[1] += multiplier*acceleration[1] - multiplier*startData[1]
            v_0[2] += multiplier*acceleration[2] - multiplier*startData[2]
            d_0[0] += v_0[0] * frequency
            d_0[1] += v_0[1] * frequency
            d_0[2] += v_0[2] * frequency
        }
        
        distance = sqrt( pow(d_0[0], 2.0) + pow(d_0[1], 2.0) + pow(d_0[2], 2.0))
        let dumb = distance * 3.28
        let feet = floor(dumb)
        let inches = round(( dumb - feet ) * 12)
        
        meters.text = String(round(distance * 100)/100)
        english.text = String(feet) + "\'" + String(inches) + "\""
    }
}

