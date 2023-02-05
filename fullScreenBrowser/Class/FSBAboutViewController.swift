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
    @IBOutlet weak var infoLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }

    func setupUI(){
        
        versionLbl.text = "v" +  (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)
        
        logoImg.isUserInteractionEnabled = true
        logoImg.layer.masksToBounds = true
        logoImg.layer.cornerRadius = 15;
        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action:#selector(tapLogoImage))
        logoImg.addGestureRecognizer(tap)
        
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy"
        let yearString = formatter.string(from: Date.init())
        self.infoLbl.text = "Copyright © 2014-" + yearString + " @iHTCboy"
    }
    
    @objc func tapLogoImage(){
        UIApplication.shared.open(URL.init(string: "https://itunes.apple.com/us/app/FullScreen/id948944368?mt=8")!, options: [:], completionHandler: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
