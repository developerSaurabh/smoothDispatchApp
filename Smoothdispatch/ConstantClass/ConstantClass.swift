//
//  ConstantClass.swift
//  Smoothdispatch
//
//  Created by Ravinder on 19/09/19.
//  Copyright © 2019 Ravinder. All rights reserved.
//

import Foundation
import UIKit

struct Constatnt {
    struct AppConstant {
        static let AppName = "Smooth Dispatch"
    }
    
    struct DomainName {
        static let domain = UserDefaults.standard.value(forKey: "DynamicDomain") as? String ?? ""
    }
    

}

