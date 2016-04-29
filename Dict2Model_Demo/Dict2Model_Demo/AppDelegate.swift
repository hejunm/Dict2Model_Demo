//
//  AppDelegate.swift
//  Dict2Model_Demo
//
//  Created by 贺俊孟 on 16/4/28.
//  Copyright © 2016年 贺俊孟. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //func1()
        //func2()
        //func3()
        //func4()
        
        func5()
        //func6()
        //func7()
        
        return true
    }
    
    /**
    1, 最简单的字典转模型
     
    name: Optional("Jack")
    icon:Optional("lufy.png")
    */
    func func1(){
        let dict = ["name":"Jack","icon":"lufy.png"]
        if let user = User.objectWithKeyValues(dict) as? User{
             print("\(user)")
        }
    }
    
    // 2, 模型中包裹模型
    /**
    text:Optional("Agree!Nice weather!")
    user:Optional(name: Optional("Jack")  icon:Optional("lufy.png"))
    retweetedStatus:Optional(text:Optional("Nice weather!")
                             user:Optional(name: Optional("Rose")icon:Optional("nami.png"))
                             retweetedStatus:nil)
    */
    func func2(){
        let dict = ["text":"Agree!Nice weather!",
                     "user":["name":"Jack",
                             "icon":"lufy.png"
                            ],
            "retweetedStatus":["text":"Nice weather!",
                                "user":["name":"Rose",
                                        "icon":"nami.png"
                                       ]
              ]
        ]
        if let status = Status.objectWithKeyValues(dict) as? Status{
            print("\(status)")
        }
       
    }

    // 3,字典中包裹数组， 数组中的元素是 一个模型对应的字典
    /**
    groupName:Optional("Dream Team")
      numbers:Optional((
                        "name: Optional(\"Jack\") \n icon:Optional(\"lufy.png\") \n",
                        "name: Optional(\"Rose\") \n icon:Optional(\"nami.png\") \n"
    ))
    */
    
    func func3(){
        let dict = ["groupName":"Dream Team",
                         "numbers":[["name":"Jack",
                                 "icon":"lufy.png"
                                ],
                                ["name":"Rose",
                                 "icon":"nami.png"
                                ]]
                    ]
        if let group = UserGroup.objectWithKeyValues(dict){
            print("\(group)")
        }
    }
    
    //4, 将一个字典数组转成模型数组
    /**
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
    
    */
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
            for item in status{
                print(item)
            }
        }
    }
    
    
    /**-----------------------------------------*/
    
     //5,  模型传字典，最简单形式    Optional(["icon": my.png, "name": hejunm])
    func func5(){
        let user = User()
        user.name = "hejunm"
        user.icon = "my.png"
        if let dict = user.keyValues{
            do{ //转化为JSON 字符串
                let data = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
                print(NSString(data: data, encoding: NSUTF8StringEncoding))
            }catch{
                
            }
        }
    }
    
    
    //6, 模型传字典， 模型中还有模型
    /**
    Optional(["text": this is original status, 
              "user": {icon = "my.png"; name = "original user";}, 
              "retweetedStatus": {
                                text = "this is retweeted status";
                                user =  {icon = "my.png";name = "retweeted user hejunm";};
                                }
            ])
    */
    func func6(){

        let user = User()
        user.name = "retweeted user hejunm"
        user.icon = "my.png"

        let retweetedStatus = Status();
        retweetedStatus.text = "this is retweeted status";
        retweetedStatus.user = user


        let oriUser = User()
        oriUser.name = "original user"
        oriUser.icon = "my.png"

        let oriStatus = Status();
        oriStatus.text = "this is original status"
        oriStatus.user = oriUser
        oriStatus.retweetedStatus = retweetedStatus

        let dict =  oriStatus.keyValues
        do{ //转化为JSON 字符串
           let data = try NSJSONSerialization.dataWithJSONObject(dict!, options: .PrettyPrinted)
            print(NSString(data: data, encoding: NSUTF8StringEncoding))
        
        }catch{
            
        }
    }
    
    //7, 模型数组转字典数组
    /**
    Optional([{
    icon = "my.png_1";
    name = "hejunm_1";
    }, {
    icon = "my.png_2";
    name = "hejunm_2";
    }])
    */
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
                let data = try NSJSONSerialization.dataWithJSONObject(dicts, options: .PrettyPrinted)
                print(NSString(data: data, encoding: NSUTF8StringEncoding))
            }catch{
                
            }
        }
    }
}

