//
//  User.swift
//  HEExtention
//
//  Created by 贺俊孟 on 16/4/27.
//  Copyright © 2016年 贺俊孟. All rights reserved.
//

import Foundation
class User: NSObject {
    var name:String?
    var icon:String?
    
    override internal var description: String {
        return "name: \(name) \n icon:\(icon) \n"
    }
}