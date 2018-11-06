//
//  FSBAboutViewController.swift
//  FullScreenBrowser
//
//  Created by HTC on 2016/11/1.
//  Copyright © 2016年 HTC. All rights reserved.
//

import UIKit
import Foundation

class FSBAboutViewController: UIViewController {

    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var versionLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }

    func setupUI(){
        
        versionLbl.text = "v" +  (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)
        
        logoImg.isUserInteractionEnabled = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action:#selector(tapLogoImage))
        logoImg.addGestureRecognizer(tap)
        
    }
    
    func tapLogoImage(){
        UIApplication.shared.openURL(URL.init(string: "https://itunes.apple.com/cn/app/gui-lin-li-gong-da-xue-yun/id948944368?mt=8")!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
