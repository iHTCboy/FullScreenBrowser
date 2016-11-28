//
//  HTTPTools.swift
//  FullScreenBrowser
//
//  Created by HTC on 2016/11/6.
//  Copyright © 2016年 iHTCboy. All rights reserved.
//

import UIKit

class HTTPTools: AFHTTPSessionManager {
    
    static let tools: HTTPTools = {
        //加载资源
        let mgr = HTTPTools()
        mgr.requestSerializer.timeoutInterval = 8.0;
        //设置
        var responseSerializer = AFJSONResponseSerializer.init(readingOptions: JSONSerialization.ReadingOptions.allowFragments)
        mgr.responseSerializer = responseSerializer;
        mgr.responseSerializer.acceptableContentTypes = NSSet.init(objects: "text/html","text/plain","application/json","text/javascript","application/x-www-form-urlencoded") as? Set<String>
        //增加必要头部参数
        mgr.requestSerializer.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        mgr.requestSerializer.setValue("OA/5.5 CFNetwork/808.0.2 Darwin/16.0.0", forHTTPHeaderField: "User-Agent")
        mgr.requestSerializer.setValue("zh-cn", forHTTPHeaderField: "Accept-Language")
        mgr.requestSerializer.setValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
        return mgr
    }()
    
    class func shareHTTPTools() -> HTTPTools {
        return tools
    }
    
    func HTTPGET(URLString: String, parameters: Any?, progress: ((Progress) -> Void)?, success: ((URLSessionDataTask, Any?) -> Void)?, failure: ((URLSessionDataTask?, Error) -> Void)?) {
        HTTPTools.shareHTTPTools().get(URLString, parameters: parameters, progress: progress, success: success, failure: failure)
    }
    
    func HTTPPOST(URLString: String, parameters: Any?, progress: ((Progress) -> Void)?, success: ((URLSessionDataTask, Any?) -> Void)?, failure: ((URLSessionDataTask?, Error) -> Void)?){
        HTTPTools.shareHTTPTools().post(URLString, parameters: parameters, progress: progress, success: success, failure: failure)
    }
    
}
