
##前言
**现在很多iOS项目的开发开始转向Swift语言。  相信 Swift语言很快会成为iOS工程师 必备技能。 字典转模型， 模型转转字典在开发过程中扮演非常重要的角色。 今天就和大家分享一下使用Swift，如何进行字典模型互转。 ** 

----------

##可以实现的功能：

###1，字典-->模型 ：最简单的形式
```
class User: NSObject {  //模型类
    var name:String?
    var icon:String?
    
   // print时会调用。相当于java中的 toString()。为了代码整洁下面的模型去了这个计算属性。测试时请下载demo
    override internal var description: String {  
        return "name: \(name) \n icon:\(icon) \n"
    }
}


 func func1(){
        let dict = ["name":"Jack","icon":"lufy.png"]
        if let user = User.objectWithKeyValues(dict) as? User{
             print("\(user)")
        }
  }
  输出： name: Optional("Jack") 
        icon: Optional("lufy.png") 
```
   


----------
###2，字典-->模型 ：模型中包裹模型
```
//模型类
class Status :NSObject {  
    var text:String?
    var user:User?        //与 1 中的模型相同
    var retweetedStatus:Status?
}

 func func2(){
      let dict = ["text":"Agree!Nice weather!",
                  "user":["name":"Jack","icon":"lufy.png"],
                  "retweetedStatus":["text":"Nice weather!",
					                 "user":["name":"Rose","icon":"nami.png"]]                                      
                 ]
                 
      if let status = Status.objectWithKeyValues(dict) as? Status{
          print("\(status)")
      }
 }
输出： 
    text:Optional("Agree!Nice weather!")
    user:Optional(name: Optional("Jack")  icon:Optional("lufy.png"))
    retweetedStatus:Optional(text:Optional("Nice weather!")
                             user:Optional(name: Optional("Rose")icon:Optional("nami.png"))
                             retweetedStatus:nil)

```


----------
###3，字典-->模型： 字典中包裹数组， 数组中的元素是 一个模型对应的字典

```
//模型类， 必须遵守DictModelProtocol协议， 并实现customClassMapping方法。
class UserGroup: NSObject,DictModelProtocol {
    var groupName:String?;            //团队名称
    var numbers:NSArray?              //成员，保存User实例
    static func customClassMapping() -> [String: String]?{
        return ["numbers":"User"];   //指定numbers数组中的元素类型是User
    }
}

func func3(){
   let dict = ["groupName":"Dream Team",
                 "numbers":[["name":"Jack","icon":"lufy.png"],
                            ["name":"Rose","icon":"nami.png"]]
               ]
   if let group = UserGroup.objectWithKeyValues(dict){
       print("\(group)")
   }
}

输出： groupName:Optional("Dream Team")
      numbers:Optional((
                        "name: Optional(\"Jack\") \n icon:Optional(\"lufy.png\") \n",
                        "name: Optional(\"Rose\") \n icon:Optional(\"nami.png\") \n"
    ))
```


----------
###4，字典-->模型： 将一个字典数组转成模型数组

```
func func4(){
        let arrayOfStatus = [["text":"Agree!Nice weather!",
                             "user":["name":"Jack",
                                     "icon":"lufy.png"
                                    ],
                            "retweetedStatus":["text":"Nice weather!",
                                                "user":["name":"Rose",
                                                        "icon":"nami.png"
                                                       ]
                                               ]
                            ],
                            ["text":"2___Agree!Nice weather!",
                              "user":["name":"2___Jack",
                                       "icon":"2___lufy.png"
                                     ],
                            "retweetedStatus":["text":"2___Nice weather!",
                                                "user":["name":"2___Rose",
                                                        "icon":"2___nami.png"
                                                       ]
                                               ]
                            ]]

        if let status = Status.objectArrayWithKeyValuesArray(arrayOfStatus){
            for item in status{ //打印出数组的元素
                print(item)
            }
        }
    }
输出： 
    text:Optional("Agree!Nice weather!")
    user:Optional(name: Optional("Jack")icon:Optional("lufy.png"))
    retweetedStatus:Optional(text:Optional("Nice weather!")
                             user:Optional(name: Optional("Rose") icon:Optional("nami.png"))
                             retweetedStatus:nil
    )
    
    text:Optional("2___Agree!Nice weather!")
    user:Optional(name: Optional("2___Jack")icon:Optional("2___lufy.png"))
    retweetedStatus:Optional(text:Optional("2___Nice weather!")
                             user:Optional(name: Optional("2___Rose")icon:Optional("2___nami.png"))
                             retweetedStatus:nil
    )

```


----------
###5 模型-->字典： 最简单形式 

```
func func5(){
        let user = User()
        user.name = "hejunm"
        user.icon = "my.png"
        if let dict = user.keyValues{
            do{ //转化为JSON 字符串，打印出来更直观
                let data = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
                print(NSString(data: data, encoding: NSUTF8StringEncoding))
            }catch{}
        }
    }
输出：    
 Optional({
  "icon" : "my.png",
  "name" : "hejunm"
})
```


----------
###6 模型-->字典： 模型中还有模型

```
func func6(){
	let user = User()
       user.name = "retweeted user hejunm"
       user.icon = "my.png"

       let retweetedStatus = Status();  //转发微博
       retweetedStatus.text = "this is retweeted status";
       retweetedStatus.user = user


       let oriUser = User()
       oriUser.name = "original user"
       oriUser.icon = "my.png"

       let oriStatus = Status(); //原微博
       oriStatus.text = "this is original status"
       oriStatus.user = oriUser
       oriStatus.retweetedStatus = retweetedStatus

       let dict =  oriStatus.keyValues
       do{ //转化为JSON 字符串
           var data = try NSJSONSerialization.dataWithJSONObject(dict!, options: .PrettyPrinted)
            print(NSString(data: data, encoding: NSUTF8StringEncoding))
        
        }catch{
            
        }
}

输出：  
 Optional({
 "text" : "this is original status",
 "user" : {
		   "icon" : "my.png",
		   "name" : "original user"
		  },
  "retweetedStatus" : {
    "text" : "this is retweeted status",
    "user" : {
      "icon" : "my.png",
      "name" : "retweeted user hejunm"
    }
  }
})
```
----------
###7，模型-->字典 ： 模型数组转字典数组

```
func func7(){
        
        let user1 = User()
        user1.name = "hejunm_1"
        user1.icon = "my.png_1"

        let user2 = User()
        user2.name = "hejunm_2"
        user2.icon = "my.png_2"

        let userArray = [user1,user2] as NSArray
       
        if let dicts = userArray.keyValuesArray{
            do{
                let data = try NSJSONSerialization.dataWithJSONObject(dicts, options: .PrettyPrinted) //转成json字符串
                print(NSString(data: data, encoding: NSUTF8StringEncoding))
            }catch{
                
            }
        }
    }

输出： 
Optional([
  {
    "icon" : "my.png_1",
    "name" : "hejunm_1"
  },
  {
    "icon" : "my.png_2",
    "name" : "hejunm_2"
  }
])
```

#源码
##字典-->模型

```
//
//  HE_Dict2Model.swift
//  HEExtention
//
//  Created by 贺俊孟 on 16/4/27.
//  Copyright © 2016年 贺俊孟. All rights reserved.
//  字典传模型


import Foundation

/** 当字典中存在数组， 并且数组中保存的值得类型是字典， 那么就需要指定数组中的字典对应的类类型。
 这里以键值对的形式保存
 eg 字典如下：
 key: [[key1:value1, key2:value2],[key1:value3, key2:value4],[key1:value5, key2:value6]]
 
 key：  key值
 value: 字典[key1:value1, key2:value2] 对应的模型
*/

@objc public protocol DictModelProtocol{
    static func customClassMapping() -> [String: String]?
}


extension NSObject{
 
    //dict: 要进行转换的字典
    class func objectWithKeyValues(dict: NSDictionary)->AnyObject?{
        if HEFoundation.isClassFromFoundation(self) {
            print("只有自定义模型类才可以字典转模型")
            assert(true)
            return nil
        }
        
        let obj:AnyObject = self.init()
        var cls:AnyClass = self.classForCoder()                                           //当前类的类型
        
        while("NSObject" !=  "\(cls)"){
            var count:UInt32 = 0
            let properties =  class_copyPropertyList(cls, &count)                         //获取属性列表
            for i in 0..<count{
                
                let property = properties[Int(i)]                                         //获取模型中的某一个属性
                
                let propertyType = String.fromCString(property_getAttributes(property))!  //属性类型
                
                let propertyKey = String.fromCString(property_getName(property))!         //属性名称
                if propertyKey == "description"{ continue  }                              //description是Foundation中的计算型属性，是实例的描述信息
                
                
                var value:AnyObject! = dict[propertyKey]      //取得字典中的值
                if value == nil {continue}
                
                let valueType =  "\(value.classForCoder)"     //字典中保存的值得类型
                if valueType == "NSDictionary"{               //1，值是字典。 这个字典要对应一个自定义的模型类并且这个类不是Foundation中定义的类型。
                    let subModelStr:String! = HEFoundation.getType(propertyType)
                    if subModelStr == nil{
                        print("你定义的模型与字典不匹配。 字典中的键\(propertyKey)  对应一个自定义的 模型")
                        assert(true)
                    }
                    if let subModelClass = NSClassFromString(subModelStr){
                        value = subModelClass.objectWithKeyValues(value as! NSDictionary) //递归
                    }
                }else if valueType == "NSArray"{              //值是数组。 数组中存放字典。 将字典转换成模型。 如果协议中没有定义映射关系，就不做处理
                    
                    if self.respondsToSelector("customClassMapping") {
                        if var subModelClassName = cls.customClassMapping()?[propertyKey]{   //子模型的类名称
                            subModelClassName =  HEFoundation.bundlePath+"."+subModelClassName
                            if let subModelClass = NSClassFromString(subModelClassName){
                                value = subModelClass.objectArrayWithKeyValuesArray(value as! NSArray);
                            }
                        }
                    }
                    
                }
                
              obj.setValue(value, forKey: propertyKey)
            }
            free(properties)                            //释放内存
            cls = cls.superclass()!                     //处理父类
        }
        return obj
    }
    
    /**
     将字典数组转换成模型数组
     array: 要转换的数组, 数组中包含的字典所对应的模型类就是 调用这个类方法的类
     
     当数组中嵌套数组， 内部的数组包含字典，cls就是内部数组中的字典对应的模型
     */
    class func objectArrayWithKeyValuesArray(array: NSArray)->NSArray?{
        if array.count == 0{
            return nil
        }
        var result = [AnyObject]()
        for item in array{
            let type = "\(item.classForCoder)"
            if type == "NSDictionary"{
                if let model = objectWithKeyValues(item as! NSDictionary){
                    result.append(model)
                }
            }else if type == "NSArray"{
                if let model =  objectArrayWithKeyValuesArray(item as! NSArray){
                    result.append(model)
                }
            }else{
                result.append(item)
            }
        }
        if result.count==0{
            return nil
        }else{
            return result
        }
    }
}

```
## 模型-->字典

```
//
//  HE_Model2Dict.swift
//  HEExtention
//
//  Created by 贺俊孟 on 16/4/27.
//  Copyright © 2016年 贺俊孟. All rights reserved.
//  模型传字典

import Foundation

extension NSObject{
    var keyValues:[String:AnyObject]?{                   //获取一个模型对应的字典
        get{
            var result = [String: AnyObject]()           //保存结果
            var classType:AnyClass = self.classForCoder
            while("NSObject" !=  "\(classType)" ){
                var count:UInt32 = 0
                let properties = class_copyPropertyList(classType, &count)
                for i in 0..<count{
                    let property = properties[Int(i)]
                    let propertyKey = String.fromCString(property_getName(property))!         //模型中属性名称
                    let propertyType = String.fromCString(property_getAttributes(property))!  //模型中属性类型
                    
                    if "description" == propertyKey{ continue }   //描述，不是属性
                    
                    let tempValue:AnyObject!  = self.valueForKey(propertyKey)
                    if  tempValue == nil { continue }
                    
                    if let _ =  HEFoundation.getType(propertyType) {         //1,自定义的类
                        result[propertyKey] = tempValue.keyValues
                    }else if (propertyType.containsString("NSArray")){       //2, 数组, 将数组中的模型转成字典
                        result[propertyKey] = tempValue.keyValuesArray       //3， 基本数据
                    }else{
                        result[propertyKey] = tempValue
                    }
                }
                free(properties)
                classType = classType.superclass()!
            }
            if result.count == 0{
                return nil
            }else{
                return result
            }
            
        }
    }
}

extension NSArray{  //数组的拓展
    var keyValuesArray:[AnyObject]?{
        get{
            var result = [AnyObject]()
            for item in self{
                if !HEFoundation.isClassFromFoundation(item.classForCoder){ //1,自定义的类
                    let subKeyValues:[String:AnyObject]! = item.keyValues
                    if  subKeyValues == nil {continue}
                    result.append(subKeyValues)
                }else if item.classForCoder == NSArray.classForCoder(){    //2, 如果item 是数组
                    let subKeyValues:[AnyObject]! = item.keyValuesArray
                    if  subKeyValues == nil {continue}
                    result.append(subKeyValues)
                }else{                                                     //3, 基本数据类型
                    result.append(item)
                }
            }
            if result.count == 0{
                return nil
            }else{
                return result
            }
            
        }
    }
}
```

##辅助类

```
//
//  HEFoundation.swift
//  HEExtention
//
//  Created by 贺俊孟 on 16/4/27.
//  Copyright © 2016年 贺俊孟. All rights reserved.


import Foundation

class HEFoundation {
    
    static let set = NSSet(array: [
                                    NSURL.classForCoder(),
                                    NSDate.classForCoder(),
                                    NSValue.classForCoder(),
                                    NSData.classForCoder(),
                                    NSError.classForCoder(),
                                    NSArray.classForCoder(),
                                    NSDictionary.classForCoder(),
                                    NSString.classForCoder(),
                                    NSAttributedString.classForCoder()
                                  ])
    static let  bundlePath = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as! String
    
    /*** 判断某个类是否是 Foundation中自带的类 */
    class func isClassFromFoundation(c:AnyClass)->Bool {
        var  result = false
        if c == NSObject.classForCoder(){
            result = true
        }else{
            set.enumerateObjectsUsingBlock({ (foundation,  stop) -> Void in
                if  c.isSubclassOfClass(foundation as! AnyClass) {
                    result = true
                    stop.initialize(true)
                }
            })
        }
        return result
    }
    
    /** 很据属性信息， 获得自定义类的 类名*/
     /**
     let propertyType = String.fromCString(property_getAttributes(property))! 获取属性类型
     到这个属性的类型是自定义的类时， 会得到下面的格式： T+@+"+..+工程的名字+数字+类名+"+,+其他,
     而我们想要的只是类名，所以要修改这个字符串
     */
    class func getType(var code:String)->String?{
        
        if !code.containsString(bundlePath){ //不是自定义类
            return nil
        }
        code = code.componentsSeparatedByString("\"")[1]
        if let range = code.rangeOfString(bundlePath){
            code = code.substringFromIndex(range.endIndex)
            var numStr = "" //类名前面的数字
            for c:Character in code.characters{
                if c <= "9" && c >= "0"{
                    numStr+=String(c)
                }
            }
            if let numRange = code.rangeOfString(numStr){
                code = code.substringFromIndex(numRange.endIndex)
            }
            return bundlePath+"."+code
        }
        return nil
    }
}

```


