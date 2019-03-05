//
//  ViewController.swift
//  buckets
//
//  Created by Avi on 3/2/19.
//  Copyright © 2019 Heatmap. All rights reserved.
//

import UIKit
import WatchConnectivity
class ViewController: UIViewController, WCSessionDelegate {
    var session : WCSession!
    @IBOutlet var xView: UILabel!
    @IBOutlet var yView: UILabel!
    @IBOutlet var zView: UILabel!
    var allData = String()
    var count = 0
    var total = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        if WCSession.isSupported() {
            session = WCSession.default
            session.delegate = self
            session.activate()
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        //let counterValue = message["counterValue"] as? String
        
        //Use this to update the UI instantaneously (otherwise, takes a little while)
        //        dispatch_async(Dispatch().dispatch_get_main_queue()) {
        //            self.roast.text = "UR BAD"
        //            //self.counterData.append(counterValue!)
        //            //self.mainTableView.reloadData()
        //        }
        let x = message["x"] as? String
        let y = message["y"] as? String
        let z = message["z"] as? String
        let accelX = message["accelX"] as? String
        let accelY = message["accelY"] as? String
        let accelZ = message["accelZ"] as? String
        let rotX = message["rotX"] as? String
        let rotY = message["rotY"] as? String
        let rotZ = message["rotZ"] as? String
        let gravX = message["gravX"] as? String
        let gravY = message["gravY"] as? String
        let gravZ = message["gravZ"] as? String
        DispatchQueue.main.async {
            // do something
            for s in [x,y,z,accelX, accelY, accelZ, rotX, rotY, rotZ, gravX, gravY, gravZ] {
                self.allData = self.allData + s! + ", "
                self.total += 1
            }
            
//            self.allData.append(x!)
//            self.allData.append(y!)
//            self.allData.append(z!)
//            self.allData.append(accelX!)
//            self.allData.append(accelY!)
//            self.allData.append(accelZ!)
//            self.allData.append(rotX!)
//            self.allData.append(rotY!)
//            self.allData.append(rotZ!)
//            self.allData.append(gravX!)
//            self.allData.append(gravY!)
//            self.allData.append(gravZ!)


            //self.allData += messageValue!
            //self.xView.text = "ROAST"
            //print(messageValue[0])
//            self.xView.text = accelX
//            self.yView.text = accelY
//            self.zView.text = accelZ
        }
    }
    
    @IBAction func saveFile(_ sender: Any) {
//        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
//        let documentsDirectoryPath = NSURL(string: documentsDirectoryPathString)!
//        let filePath = documentsDirectoryPath.appendingPathComponent("test_roast" + String(count) + ".json")
//        count += 1
//        (allData as NSArray).write(to: filePath as! URL, atomically: true)
//
//        let savedArray = NSArray(contentsOf: filePath as! URL) as! [String]
//        for val in allData {
//            print(val, terminator: ", ")
//        }
//        let str = "Super long string here"
        let filename = getDocumentsDirectory().appendingPathComponent("roaster" + String(self.count) + ".txt")
        self.count += 1
        
        do {
            try allData.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
            allData = String()
            print("coore")
        } catch {
            print("we are bad")
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
        self.xView.text = "DONE!"
        self.yView.text = String(self.total)




    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

}

