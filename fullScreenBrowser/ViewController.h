//
//  ViewController.h
//  fullScreenBrowser
//
//  Created by HTC on 14/12/7.
//  Copyright (c) 2014年 HTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIWebView *uiWebView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbars;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *stopButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *reloadingButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *homeButton;
@property (weak, nonatomic) IBOutlet UIToolbar *fullscreenButton;
- (IBAction)goHome:(id)sender;
- (IBAction)toFullScreen:(id)sender;

- (IBAction)srarchButtonHiden:(id)sender;

- (IBAction)setingButton:(id)sender;


@end
