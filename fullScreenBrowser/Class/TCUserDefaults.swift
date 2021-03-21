//
//  TCUserDefaults.swift
//  iEnglish
//
//  Created by HTC on 2017/6/11.
//  Copyright © 2017年 iHTCboy. All rights reserved.
//

import UIKit

class TCUserDefaults: NSObject {
    
    @objc static let shared = TCUserDefaults()
    let df = UserDefaults.standard
    
    class func shareUD() -> TCUserDefaults {
        return shared
    }
    
    func setTCValue(value: Any?, forKey key: String){
        df.set(value, forKey: key)
        df.synchronize()
    }
    
    func getTCValue(key: String) -> Any? {
        return df.value(forKey: key)
    }
    
    // MARK: 浏览器设置
    @objc open func getFSBMainPage() -> String {
        if let language = getTCValue(key: "FSBMainPageKey") as? String {
            return language
        }
        return  "https://www.bing.com"
    }
    
    @objc open func setIFSBMainPage(value: String) {
        setTCValue(value: value, forKey: "FSBMainPageKey")
    }
    
    @objc open func getFSBSearchPage() -> String {
        if let language = getTCValue(key: "FSBSearchPageKey") as? String {
            return language
        }
        return  "https://www.bing.com/search?q="
    }
    
    @objc open func setIFSBSrarchPage(value: String) {
        setTCValue(value: value, forKey: "FSBSearchPageKey")
    }
    
}
