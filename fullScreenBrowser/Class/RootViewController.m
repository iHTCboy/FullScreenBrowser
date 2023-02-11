//
//  ViewController.m
//  fullScreenBrowser
//
//  Created by HTC on 14/12/1.
//  Copyright (c) 2014年 HTC. All rights reserved.
//

#import "RootViewController.h"
#import "FSBSetingViewController.h"
#import "Utility.h"
#import "BaiduMobStat.h"

#import "FSB-Swift.h"
#import <SafariServices/SafariServices.h>

#define topHight (iPhone_X_S ? 44 : 0)
#define indcatorHight (iPhone_X_S ? 34 : 0)
#define navBarHight (iPhone_X_S ? 68 : 44)
#define  MACRO_IS_GREATER_OR_EQUAL_TO_IOS(v) ([[[UIDevice currentDevice] systemVersion] floatValue] >= v)
#define iPhone_X_S (MACRO_IS_GREATER_OR_EQUAL_TO_IOS(11.0) ? \
    ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? NO :\
    (!UIEdgeInsetsEqualToEdgeInsets([[[UIApplication sharedApplication].keyWindow valueForKey:@"safeAreaInsets"] UIEdgeInsetsValue], UIEdgeInsetsZero)) : NO)


@interface RootViewController ()<UISearchBarDelegate, UIScrollViewDelegate, WKUIDelegate, WKNavigationDelegate, SFSafariViewControllerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webviewTopSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webviewBottomSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarHiddenConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchbarTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchbarHiddenConstraint;


@property (nonatomic, assign) float oldY;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 显示状态栏
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    // 设置允许摇一摇功能
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;  
    
    /// SearchBar
    self.searchBar.delegate = self;
    self.searchBar.tintColor = [UIColor colorWithRed:0.0/255 green:185.0/255 blue:253.0/255 alpha:1];
    self.searchBar.barTintColor = [UIColor colorWithRed:0.0/255 green:185.0/255 blue:253.0/255 alpha:1];
    if (@available(iOS 13.0, *)) {
        self.searchBar.searchTextField.textColor = [UIColor labelColor];
        self.searchBar.searchTextField.tintColor = [UIColor colorWithRed:0.0/255 green:185.0/255 blue:253.0/255 alpha:1];
    }
    
    // ToolBar
    self.toolbars.tintColor = [UIColor colorWithRed:0.0/255 green:185.0/255 blue:253.0/255 alpha:1];
    self.backButton.enabled = NO;
    self.forwarButton.enabled = NO;
    
    /// WKWebview
    self.wkWebView.UIDelegate = self;
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.scrollView.delegate = self;
    if (@available(iOS 13.0, *)) {
        self.wkWebView.backgroundColor = [UIColor secondarySystemBackgroundColor];
        self.wkWebView.scrollView.backgroundColor = [UIColor secondarySystemBackgroundColor];
    } else {
        self.wkWebView.backgroundColor = [UIColor whiteColor];
    }
    self.wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    self.wkWebView.scalesPageToFit = YES;
//    self.uiWebView.scrollView.showsHorizontalScrollIndicator = NO;
//    self.uiWebView.scrollView.showsVerticalScrollIndicator = NO;
    
    [self setupUI];
    
    // webview
    [self initWebViewPage];
    
    [self showPrivacy];
}

- (void)initWebViewPage
{
    NSURL *url = [self getURLWithString:TCUserDefaults.shared.getFSBMainPage];
    //url = [NSURL URLWithString:@"https://ihtcboy.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.wkWebView loadRequest:request];
}

- (void)showPrivacy
{
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    
    if (![df boolForKey:@"TheUserTermsAndConditions"]) {
        
        self.searchBar.hidden = YES;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:HTCLocalized(@"User Terms") message:HTCLocalized(@"User Terms Desc") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:HTCLocalized(@"Agree to Agreement") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [df setBool:YES forKey:@"TheUserTermsAndConditions"];
            [self initWebViewPage];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:HTCLocalized(@"View Agreement") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self inSafariOpenWithURL:@"https://raw.githubusercontent.com/iHTCboy/FullScreenBrowser/master/LICENSE"];
        }];
        
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self presentViewController:alert animated:YES completion:nil];
        });
    }
}

- (void)setupUI
{
    BOOL isHiddenSearchBar = TCUserDefaults.shared.getFSBHiddenAddressBar;
    [self.searchBar setHidden:isHiddenSearchBar];
    [self searchbarShow:!isHiddenSearchBar];
    
    float top = TCUserDefaults.shared.getFSBEdgeInsetTopValue;
    float left = TCUserDefaults.shared.getFSBEdgeInsetLeftValue;
    float right = TCUserDefaults.shared.getFSBEdgeInsetRightValue;
    float bottom = TCUserDefaults.shared.getFSBEdgeInsetBottomValue;
    //top, left, bottom, right;
    self.wkWebView.scrollView.contentInset = UIEdgeInsetsMake(top, left, bottom, right);
//    self.wkWebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIEdgeInsets inset = [[UIApplication sharedApplication].keyWindow safeAreaInsets];
    float top = inset.top;
    float bottom = inset.bottom;
    self.webviewTopSpaceConstraint.constant = -top;
    self.webviewBottomSpaceConstraint.constant = -bottom;
    
//    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
//    if (![df boolForKey:@"FirstLaunchingApp"]) {
//        [df setBool:YES forKey:@"FirstLaunchingApp"];
//        self.wkWebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, bottom, 0);
//        [TCUserDefaults.shared setIFSBEdgeInsetBottomWithValue:bottom];
//    }
}

/**
 *  从Safari打开
 */
- (void)inSafariOpenWithURL:(NSString *)url
{
    SFSafariViewController * sf = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url]];
    sf.delegate = self;
    if (@available(iOS 11.0, *)) {
        sf.preferredBarTintColor = [UIColor colorWithRed:(66)/255.0 green:(156)/255.0 blue:(249)/255.0 alpha:1];
        sf.dismissButtonStyle = SFSafariViewControllerDismissButtonStyleDone;
        sf.preferredControlTintColor = [UIColor whiteColor];
    }
    [self presentViewController:sf animated:YES completion:nil];
}

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller
{
    [self initWebViewPage];
}

- (NSURL *)getURLWithString:(NSString *)str
{
    NSString *urlStr = str;
    NSURL *url = nil;
    
    if ([str hasPrefix:@"http://"] || [str hasPrefix:@"https://"] ){
        url = [NSURL URLWithString:urlStr];

    }else if([str hasPrefix:@"www."] || [str hasPrefix:@"wap."] || [str hasPrefix:@"m."]){
     
        urlStr = [NSString stringWithFormat:@"http://%@", str];
        url = [NSURL URLWithString:urlStr];
    }
    
    return url;
}

// 让浏览器加载指定的字符串,使用m.baidu.com进行搜索
- (void)loadString:(NSString *)str
{
    // 1. URL 定位资源,需要资源的地址
    NSString *urlStr = str;
    NSURL *url = [self getURLWithString:str];
    
    if (url) {
        
    }else{
        urlStr = [NSString stringWithFormat:@"%@%@", TCUserDefaults.shared.getFSBSearchPage, str];
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        url = [NSURL URLWithString:urlStr];
    }
    
    // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 3. 发送请求给服务器
    [self.wkWebView loadRequest:request];
}

#pragma mark - 搜索栏代理
// 开始搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //NSLog(@"%@", searchBar.text);
    [self loadString:searchBar.text];
    
    [self.view endEditing:YES];
}

// 文本改变
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{

   // NSLog(@"searchText - %@", searchText);
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.searchBar.showsCancelButton = YES;
    return YES;

}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    self.searchBar.showsCancelButton = NO;
    [self.view endEditing:YES];
    
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchBar.showsCancelButton = NO;
    [self.view endEditing:YES];
}

#pragma mark - WebView代理方法
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    self.activityView.hidden = NO;
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    self.activityView.hidden = YES;
}


- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    self.activityView.hidden = YES;
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    //NSLog(@"网页加载内容进程终止");
    self.activityView.hidden = YES;
}

#pragma mark 完成加载
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    // 根据webView当前的状态,来判断按钮的状态
    self.backButton.enabled = webView.canGoBack;
    self.forwarButton.enabled = webView.canGoForward;
    
    self.activityView.hidden = YES;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    // 根据webView当前的状态,来判断按钮的状态
    self.backButton.enabled = webView.canGoBack;
    self.forwarButton.enabled = webView.canGoForward;
    
    //NSLog(@"request-----%@",request);
    NSURLRequest *request = navigationAction.request;
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:request];
    }
    
    self.searchBar.text = [NSString stringWithFormat:@"%@",request.URL];
    // 实现WebView的代理方法，并在此函数中调用SDK的webviewStartLoadWithRequest:传入request参数，进行统计
    [[BaiduMobStat defaultStat] webviewStartLoadWithRequest:request];
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

//- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
//    NSLog(@"跳转到其他的服务器");
//
//}


#pragma mark TabBar栏事件
// 后退
- (IBAction)clickedBack:(id)sender {
    if ([self.wkWebView canGoBack]) {
        [self.wkWebView goBack];
    }
}

// 前进
- (IBAction)clickedForward:(id)sender {
    if ([self.wkWebView canGoForward]) {
          [self.wkWebView goForward];
      }
}

// 刷新
- (IBAction)clickedReload:(id)sender {
    [self.wkWebView reload];
}

// 强制刷新
- (IBAction)clickedReloadButtonRepeat:(id)sender {
    [self.wkWebView reloadFromOrigin];
}

//隐藏搜索框
- (IBAction)clickedSrarchButton:(id)sender {
    if (TCUserDefaults.shared.getFSBHiddenAddressBar) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:HTCLocalized(@"Tips") message:HTCLocalized(@"Forcibly hidden") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:HTCLocalized(@"OK") style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    self.searchBar.hidden = !self.searchBar.hidden;
}

// 双击搜索键
- (IBAction)clickedSrarchButtonRepeat:(id)sender {
    
    if (TCUserDefaults.shared.getFSBSettingsPasswordStatus) {
        // 需要校验密码成功才能进入设置
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:HTCLocalized(@"Verify setup password") message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = HTCLocalized(@"Set Settings Password");
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.keyboardType = UIKeyboardTypeDefault;
            textField.returnKeyType = UIReturnKeyDone;
        }];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:HTCLocalized(@"Verify") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *ps = [[alertController textFields][0] text];
            NSString *password = TCUserDefaults.shared.getFSBSettingsPasswordValue;
            // 校验密码
            if (ps.length > 0 && ps == password) {
                [self openSettingsPage];
            } else {
                // error
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:HTCLocalized(@"Tips") message:HTCLocalized(@"Password is incorrect") preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:HTCLocalized(@"OK") style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
        [alertController addAction:confirmAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:HTCLocalized(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    [self openSettingsPage];
}

// 打开设置页面
- (void)openSettingsPage {
    //获取storyboard: 通过bundle根据storyboard的名字来获取我们的storyboard,
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    //由storyboard根据myView的storyBoardID来获取我们要切换的视图
    UINavigationController *vc = (UINavigationController *)[story instantiateViewControllerWithIdentifier:@"FSBNavigationController"];
    FSBSetingViewController * svc = (FSBSetingViewController *)vc.viewControllers.firstObject;
    svc.callback = ^(){
        [self setupUI];
    };
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)clickedHome:(id)sender {
    NSURL *url = [NSURL URLWithString:TCUserDefaults.shared.getFSBMainPage];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.wkWebView loadRequest:request];
}

- (IBAction)toFullScreen:(id)sender {
    // 隐藏
    [self toolbarShow:NO];
    [self searchbarShow:NO];
}


- (void)toolbarShow:(BOOL)show {
    if (show) {
        [UIView animateWithDuration:0.3f animations:^{
            self.toolbarHiddenConstraint.priority = 750;
            self.toolbarBottomConstraint.priority = 1000;
        }];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            self.toolbarBottomConstraint.priority = 750;
            self.toolbarHiddenConstraint.priority = 1000;
            
        }];
    }
}


- (void)searchbarShow:(BOOL)show {
    if (show) {
        if (TCUserDefaults.shared.getFSBHiddenAddressBar) {
            return;
        }
        [UIView animateWithDuration:0.3f animations:^{
            self.searchbarHiddenConstraint.priority = 750;
            self.searchbarTopConstraint.priority = 1000;
        }];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            self.searchbarTopConstraint.priority = 750;
            self.searchbarHiddenConstraint.priority = 1000;
        }];
    }
}

#pragma mark - scrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.activityView.hidden = YES;
    
    static float newY = 0;
    newY = scrollView.contentOffset.y;
    
//    NSLog(@"%f", newY);
//    if (newY != _oldY)
//    {
//        //向下滚动
//        if (newY > _oldY && (newY - _oldY) > 0)
//        {
//
//            // 隐藏
//            [self searchbarShow:NO];
//            [self toolbarShow:NO];
//
//            _oldY = newY;
//
//        }else if (newY < _oldY && (_oldY - newY) > 100){
//            [self.view endEditing:YES];
//
//            // 显示
//            [self searchbarShow:YES];
//            [self toolbarShow:YES];
//
//            _oldY = newY;
//        }
//
//    }
//
    CGPoint translatedPoint = [scrollView.panGestureRecognizer translationInView:scrollView];

    if (translatedPoint.y < 0) {
        //NSLog(@"上滑");
        // 隐藏
        [self searchbarShow:NO];
        [self toolbarShow:NO];
    }
    if (translatedPoint.y > 0) {
        //NSLog(@"下滑");
        // 显示
        [self searchbarShow:YES];
        [self toolbarShow:YES];
    }
    //通过translatedPoint.x 判断左右滑动方向
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    // 显示
    [self searchbarShow:YES];
    [self toolbarShow:YES];

    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    // 显示
    [self searchbarShow:YES];
    [self toolbarShow:YES];
}


#pragma mark - status bar
- (BOOL)prefersStatusBarHidden
{
    return YES;
}



#pragma mark - motion event
- (BOOL)canBecomeFirstResponder
{
    return YES;// default is NO
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    //NSLog(@"开始摇动手机");
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    //NSLog(@"stop");
    [self searchbarShow:YES];
    [self toolbarShow:YES];
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    //NSLog(@"取消");
}


@end
