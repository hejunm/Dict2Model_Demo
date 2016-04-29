//
//  UserGroup.swift
//  Dict2Model_Demo
//
//  Created by 贺俊孟 on 16/4/28.
//  Copyright © 2016年 贺俊孟. All rights reserved.
//

import Foundation
class UserGroup: NSObject,DictModelProtocol {
    var groupName:String?;    //团队名称
    var numbers:NSArray?       //成员
    
//    override internal var description: String {
//        return "groupName: \(groupName) \n numbers:\(numbers) \n"
//    }
    
    static func customClassMapping() -> [String: String]?{
        return ["numbers":"User"];
    }
}