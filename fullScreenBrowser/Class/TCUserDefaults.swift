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
    
    // 隐藏地址栏功能
    @objc open func getFSBHiddenAddressBar() -> Bool {
        if let hidden = getTCValue(key: "FSBHiddenAddressBarKey") as? Bool {
            return hidden
        }
        return  false
    }
    
    @objc open func setIFSBHiddenAddressBar(value: Bool) {
        setTCValue(value: value, forKey: "FSBHiddenAddressBarKey")
    }
    
    @objc open func getFSBSettingsPasswordStatus() -> Bool {
        if let hidden = getTCValue(key: "FSBSettingsPasswordStatusKey") as? Bool {
            return hidden
        }
        return  false
    }
    
    @objc open func setIFSBSettingsPasswordStatus(value: Bool) {
        setTCValue(value: value, forKey: "FSBSettingsPasswordStatusKey")
    }
    
    @objc open func getFSBSettingsPasswordValue() -> String {
        if let language = getTCValue(key: "FSBSettingsPasswordValueKey") as? String {
            return language
        }
        return  ""
    }
    
    @objc open func setIFSBSettingsPassword(value: String) {
        setTCValue(value: value, forKey: "FSBSettingsPasswordValueKey")
    }
    
}
