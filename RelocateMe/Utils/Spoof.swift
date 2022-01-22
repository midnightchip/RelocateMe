//
//  Utils.swift
//  RelocateMe
//  Inspired by Original Objective-C Bindings from https://github.com/udevsharold/locsim
//
//  Created by MidnightChips on 1/10/22.
//
import CoreLocation
import Foundation

func postTimezoneUpdate() {
    CFNotificationCenterPostNotificationWithOptions(CFNotificationCenterGetDarwinNotifyCenter(), CFNotificationName("AutomaticTimeZoneUpdateNeeded" as CFString), nil, nil, kCFNotificationDeliverImmediately)
}

func startLocationSim(loc: CLLocation, delivery: Int = 0, repeated: Int = 0) {
    let simManager = CLSimulationManager()
    if (delivery >= 0) {
        simManager.locationDeliveryBehavior = UInt8(delivery)
    }
    if (repeated >= 0) {
        simManager.locationRepeatBehavior = UInt8(repeated)
    }
    simManager.stopLocationSimulation()
    simManager.clearSimulatedLocations()
    simManager.appendSimulatedLocation(loc)
    simManager.flush()
    simManager.startLocationSimulation()
    postTimezoneUpdate()
}

func startScenarioSim(path: URL, delivery: Int = 0, repeated: Int = 0) {
    let manager = CLSimulationManager()
    if (delivery >= 0) {
        manager.locationDeliveryBehavior = UInt8(delivery)
    }
    if (repeated >= 0) {
        manager.locationRepeatBehavior = UInt8(repeated)
    }
    manager.stopLocationSimulation()
    manager.clearSimulatedLocations()
    manager.loadScenario(fromURL: path)
    manager.flush()
    manager.startLocationSimulation()
    postTimezoneUpdate()
}

func stopLocSim() {
    let manager = CLSimulationManager()
    manager.stopLocationSimulation()
    manager.clearSimulatedLocations()
    manager.flush()
    postTimezoneUpdate()
}

func forceStopSim() {
    let filemgr = FileManager()
    if filemgr.fileExists(atPath: "/usr/libexec/relocateme/forcestop") {
        let task = NSTask()
        task.setLaunchPath("/usr/libexec/relocateme/forcestop")
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        task.waitUntilExit()
        
        let data = try? pipe.fileHandleForReading.readToEnd()
        if let data = data {
            let dataString = String(data: data, encoding: .utf8)
            print(dataString ?? "Unknown")
        }
    }
}
