//
//  Status.swift
//  HEExtention
//
//  Created by 贺俊孟 on 16/4/27.
//  Copyright © 2016年 贺俊孟. All rights reserved.
//

import Foundation
class Status :NSObject {
    var text:String?
    var user:User?
    var retweetedStatus:Status?
    
    //描述， 可以在调试的时候打印输出
    override internal var description: String {
        return "{text:\(text)\n user:\(user)\n  retweetedStatus:\(retweetedStatus)\n}"
    }
}