//
//  InterfaceController.swift
//  buckets WatchKit Extension
//
//  Created by Avi on 3/2/19.
//  Copyright © 2019 Heatmap. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion
import HealthKit
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    
    @IBOutlet var xLocation: WKInterfaceLabel!
    @IBOutlet var yLocation: WKInterfaceLabel!
    @IBOutlet var zLocation: WKInterfaceLabel!
    var motion: CMMotionManager!
    let queue = OperationQueue()
    var timer: Timer?
    var count = 0
//    var allData = [[[Any]]]()
//    var shot = [[Any]]()
    var allData = [String]()
    var workout: HKWorkoutSession!
    var active = false
    var session : WCSession!
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
    }
    
    override init() {
        // Serial queue for sample handling and calculations.

    }
    
    @IBAction func start() {
//        print("helllllllllo")
        //print(String(self.active))
        //print(String(self.timer == nil))
        //if (!(self.active) || (!(self.timer == nil))) {
        self.motion = CMMotionManager()
        self.motion.startAccelerometerUpdates()
//        print(self.motion.isAccelerometerActive)
//        print(self.motion.isDeviceMotionAvailable)
        
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .other
        let healthStore = HKHealthStore()
        self.workout = try? HKWorkoutSession(healthStore: healthStore, configuration: workoutConfiguration)
        self.workout.startActivity(with: Date())
        self.queue.maxConcurrentOperationCount = 1
        self.queue.name = "MotionManagerQueue"
        self.motion.startDeviceMotionUpdates(to: self.queue) { (deviceMotion: CMDeviceMotion?, error: Error?) in
            if error != nil {
                print("Encountered error: \(error!)")
            }
            
            if deviceMotion != nil {
                self.startDeviceMotion()
            }
        }
//        shot = [[String]]()
        count = 0
        self.timer = nil
        WKInterfaceDevice.current().play(.success)
        self.startDeviceMotion()
        //allData.append(shot)
//        print(self.motion.isAccelerometerActive)
//        print(self.motion.isDeviceMotionAvailable)
        //}
    }
    
    @IBAction func stop() {
        
        for element in allData {
            print(element, terminator:", ")
        }
        self.allData = [String]()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to usersuper.willActivate()
        super.willActivate()
        if (timer == nil) {
            motion = CMMotionManager()
            motion.startAccelerometerUpdates()
//            print(motion.isAccelerometerActive)
//            print(motion.isDeviceMotionAvailable)
            
        }
        if (WCSession.isSupported()) {
            session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func startDeviceMotion() {
        //stop()
        if motion.isDeviceMotionAvailable{// && self.timer == nil {
            self.motion.deviceMotionUpdateInterval = 1.0 / 10.0
            self.motion.accelerometerUpdateInterval = 1.0 / 10.0

            self.motion.showsDeviceMovementDisplay = true
            self.motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
            
            // Configure a timer to fetch the motion data.
//            self.xLocation.setText("Out of loop")
            self.active = true
//            timer.invalidate()
            //self.timer = Timer.scheduledTimerWithTimeInterval((1.0 / 60.0),selector: "onTick:", userInfo: nil,  repeats: true)
            if (self.timer == nil) {
                self.timer = Timer.scheduledTimer(timeInterval: (1.0 / 20.0),
                                                  target: self,
                                                  selector: #selector(InterfaceController.onTick),
                                                  userInfo: nil,
                                                  repeats: true)
//                self.timer?.tolerance = 0.2
            }
            
            
            
            
//            self.timer = Timer.(fire: Date(), interval: (1.0 / 60.0), repeats: true,
//                               block: { _ in @escaping (timer); in
//                                if let data = self.motion.deviceMotion {
//                                    // Get the attitude relative to the magnetic north reference frame.
////                                    self.xLocation.setText("In loop")
//                                    if (self.active) {
//                                        let x = data.attitude.pitch
//                                        let y = data.attitude.roll
//                                        let z = data.attitude.yaw
//                                        self.xLocation.setText(String(x))
//                                        self.yLocation.setText(String(y))
//                                        self.zLocation.setText(String(z))
//                                        print(x)
//                                        print(y)
//                                        print(z)
//                                    } else {
////                                        self.timer.invalidate()
////                                        self.timer = nil
////                                        self.active = false
//                                    }
//                                    // Use the motion data in your app.
//                                }
//
//            })
            
            // Add the timer to the current run loop.
//            self.xLocation.setText("Out of loop 2")
            //RunLoop.current.add(self.timer!, forMode: RunLoop.Mode.default)
        } else {
//            self.xLocation.setText("Not available")

        }
    }
    
    @objc func onTick(){
        if let data = self.motion.deviceMotion {
            // Get the attitude relative to the magnetic north reference frame.
            //                                    self.xLocation.setText("In loop")
            //if (self.active) {
            count+=1
            let x = data.attitude.pitch
            let y = data.attitude.roll
            let z = data.attitude.yaw
            let sample = [data.attitude.pitch, data.attitude.roll, data.attitude.yaw,
                       data.userAcceleration.x, data.userAcceleration.y, data.userAcceleration.z,
                       data.rotationRate.x, data.rotationRate.y, data.rotationRate.z,
                       data.gravity.x, data.gravity.y, data.gravity.z]
//            let sample = [data.userAcceleration.x, data.userAcceleration.y, data.userAcceleration.z]
            var stringified = [String]()
            for s in sample {
                stringified.append(String(s))
            }
            if (WCSession.default.isReachable) {
                // this is a meaningless message, but it's enough for our purposes
                let message = ["x": stringified[0], "y": stringified[1], "z": stringified[2],
                               "accelX": stringified[3], "accelY": stringified[4], "accelZ": stringified[5],
                               "rotX": stringified[6], "rotY": stringified[7], "rotZ": stringified[8],
                               "gravX": stringified[9], "gravY": stringified[10], "gravZ": stringified[11]] //[0][0][0]]
                WCSession.default.sendMessage(message, replyHandler: nil)
            }
//            for s in sample {
//
//                allData.append(String(s))
//            }
            //print(stringified)
//            shot.append(stringified)
            //print(shot)
//            print(sample)
            self.xLocation.setText(String(x))
            self.yLocation.setText(String(y))
            self.zLocation.setText(String(z))
//            print(x)
//            print(y)
//            print(z)
//            print(count)
            //}
            if count >= 240 {
//                allData.append(shot)
                WKInterfaceDevice.current().play(.success)
                self.timer?.invalidate()
                self.timer = nil
            }
            
            
        }
    }

}
