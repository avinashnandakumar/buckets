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

class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var xLocation: WKInterfaceLabel!
    @IBOutlet var yLocation: WKInterfaceLabel!
    @IBOutlet var zLocation: WKInterfaceLabel!
    var motion: CMMotionManager!
    let queue = OperationQueue()
    var timer: Timer!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
    }
    
    override init() {
        // Serial queue for sample handling and calculations.

    }
    
    @IBAction func start() {
        queue.maxConcurrentOperationCount = 1
        queue.name = "MotionManagerQueue"
        motion.startDeviceMotionUpdates(to: queue) { (deviceMotion: CMDeviceMotion?, error: Error?) in
            if error != nil {
                print("Encountered error: \(error!)")
            }
            
            if deviceMotion != nil {
                self.startDeviceMotion()
            }
        }
        startDeviceMotion()
        print(motion.isAccelerometerActive)
        print(motion.isDeviceMotionAvailable)
    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        motion = CMMotionManager()
        motion.startAccelerometerUpdates()
        print(motion.isAccelerometerActive)
        print(motion.isDeviceMotionAvailable)
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func startDeviceMotion() {
        if motion.isDeviceMotionAvailable {
            self.motion.deviceMotionUpdateInterval = 1.0 / 60.0
            self.motion.showsDeviceMovementDisplay = true
            self.motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
            
            // Configure a timer to fetch the motion data.
//            self.xLocation.setText("Out of loop")
            self.timer = Timer(fire: Date(), interval: (1.0 / 60.0), repeats: true,
                               block: { (timer) in
                                if let data = self.motion.deviceMotion {
                                    // Get the attitude relative to the magnetic north reference frame.
//                                    self.xLocation.setText("In loop")
                                    let x = data.attitude.pitch
                                    let y = data.attitude.roll
                                    let z = data.attitude.yaw
                                    self.xLocation.setText(String(x))
                                    self.yLocation.setText(String(y))
                                    self.zLocation.setText(String(z))
                                    print(x)
                                    print(y)
                                    print(z)
                                    // Use the motion data in your app.
                                }
            })
            
            // Add the timer to the current run loop.
//            self.xLocation.setText("Out of loop 2")
            RunLoop.current.add(self.timer!, forMode: RunLoop.Mode.default)
        } else {
            self.xLocation.setText("Not available")

        }
    }

}
