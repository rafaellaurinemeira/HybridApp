//
//  Bridge.swift
//  HybridApp
//
//  Created by Rafael Laurine Meira on 21/08/17.
//  Copyright © 2017 RLDeveloper. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc
public protocol CommunicationProtocol: JSExport {
    func exec(_ funcName: String, _ args: [Any])
}

open class Bridge: NSObject, CommunicationProtocol {
    let cameraUtils = CameraUtils()
    
    public func exec(_ funcName: String, _ args: [Any]) {
        switch funcName {
        case "openCamera":
            let success = args[0] as! String
            let error = args[1] as! String
            let quality = args[2] as! Int
            cameraUtils.open(success, error: error, with: quality)
        default:
            break
        }
    }
}
