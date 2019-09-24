//
//  AssistantManager.swift
//  ScopeAgent-Reference
//
//  Copyright © 2019 Undefined Labs. All rights reserved.
//

/**
 * SCOPE
 *
 * Assistant Manager class represent an internal application class.
 * ScopeAgent is not imported here
 */

import Foundation
import os

class AssistantManager {
    
    enum AssistantStatus {
        case ready
        case warning
        case error
    }
    
    static let shared = AssistantManager()
    
    var status: AssistantStatus
    var sensors = HeatSensors()
    
    private init() {
        status = .ready
    }

    func provideAssistance() {
        usleep( arc4random_uniform(1_000_000) )
        self.status = .ready
    }
    
    func notifySystem() {
        usleep( arc4random_uniform(1_000_000) )
    }
    
    func checkHeatAverage() -> Int {
        
        var maxTemp = 0
        let sensorsCount = sensors.sensorArray.count
        for index in 0 ... sensorsCount {
            maxTemp += sensors.getHeatAtSensor(index: index)
        }
        return maxTemp/sensorsCount
    }
    
    func checkCameraPosition() -> Bool {
        usleep( arc4random_uniform(1_000_000) )

        if(self.status != .ready) {
            Logger.logError("Camera not ready")
            NSException.init(name: NSExceptionName.init("CameraMalfunction"), reason: "cameraAxis position", userInfo: ["angle": "0.124 degress"]).raise();
            return false;
        }
        print("Camera OK")
        return true;
    }
    
    func checkStandardLoggging() {
        NSLog("Message logged with NSLog(). It uses stderr stream")
        print("Message logged with print(). It uses stdout stream")
        os_log("Message logged with os_log(). It uses stderr stream")
    }
}


