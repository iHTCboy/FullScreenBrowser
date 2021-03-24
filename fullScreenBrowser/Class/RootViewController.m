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


@interface RootViewController ()<UISearchBarDelegate, UIScrollViewDelegate, WKUIDelegate, WKNavigationDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarHiddenConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchbarTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchbarHiddenConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBarToiPhoneXConstraint;


@property (nonatomic, assign) float oldY;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.searchBar.delegate = self;
    self.wkWebView.UIDelegate = self;
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.scrollView.delegate = self;
    if (@available(iOS 13.0, *)) {
        self.wkWebView.backgroundColor = [UIColor secondarySystemBackgroundColor];
        self.wkWebView.scrollView.backgroundColor = [UIColor secondarySystemBackgroundColor];
    }
    
    if (!iPhone_X_S) {
        [UIView animateWithDuration:0.1 animations:^{
            self.searchBarToiPhoneXConstraint.priority = 250;
            self.searchbarHiddenConstraint.priority = 750;
            self.searchbarTopConstraint.priority = 1000;
        }];
    }
    

// self.searchBar.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.850];
    self.searchBar.tintColor = [UIColor colorWithRed:0.0/255 green:185.0/255 blue:253.0/255 alpha:1];
    self.searchBar.barTintColor = [UIColor colorWithRed:0.0/255 green:185.0/255 blue:253.0/255 alpha:1];
    if (@available(iOS 13.0, *)) {
        self.searchBar.searchTextField.textColor = [UIColor labelColor];
        self.searchBar.searchTextField.tintColor = [UIColor colorWithRed:0.0/255 green:185.0/255 blue:253.0/255 alpha:1];
    }
    //self.searchBar.showsCancelButton = YES;
    
    if (@available(iOS 13.0, *)) {
        self.wkWebView.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.wkWebView.backgroundColor = [UIColor whiteColor];
    }
    
    if (iPhone_X_S) {
        self.wkWebView.scrollView.contentInset = UIEdgeInsetsMake(60, 0, 120, 0);
    } else {
        self.wkWebView.scrollView.contentInset = UIEdgeInsetsMake(60, 0, 100, 0);
    }
//    self.wkWebView.scalesPageToFit = YES;
//    self.uiWebView.scrollView.showsHorizontalScrollIndicator = NO;
//    self.uiWebView.scrollView.showsVerticalScrollIndicator = NO;
    
    
//    self.toolbars.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.90];
    self.toolbars.tintColor = [UIColor colorWithRed:0.0/255 green:185.0/255 blue:253.0/255 alpha:1];
   // self.toolbars.barTintColor = [UIColor colorWithRed:0.0/255 green:185.0/255 blue:253.0/255 alpha:1];
    
    
    self.backButton.enabled = NO;
    self.forwarButton.enabled = NO;

    
    // 显示状态栏
    [UIApplication sharedApplication].statusBarHidden = YES;
    //[[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    
    
    NSURL *url = [NSURL URLWithString:TCUserDefaults.shared.getFSBMainPage];
    // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 3. 发送请求给服务器
    [self.wkWebView loadRequest:request];
    
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    
    if (![df boolForKey:@"TheUserTermsAndConditions"]) {
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:HTCLocalized(@"User Terms") message:HTCLocalized(@"User Terms Desc") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:HTCLocalized(@"Agree to Agreement") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [df setBool:YES forKey:@"TheUserTermsAndConditions"];
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
    
    // 设置允许摇一摇功能
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;  
}

/**
 *  从Safari打开
 */
- (void)inSafariOpenWithURL:(NSString *)url
{
    SFSafariViewController * sf = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url]];
    if (@available(iOS 11.0, *)) {
        sf.preferredBarTintColor = [UIColor colorWithRed:(66)/255.0 green:(156)/255.0 blue:(249)/255.0 alpha:1];
        sf.dismissButtonStyle = SFSafariViewControllerDismissButtonStyleDone;
        sf.preferredControlTintColor = [UIColor whiteColor];
    }
    [self presentViewController:sf animated:YES completion:nil];
}


// 让浏览器加载指定的字符串,使用m.baidu.com进行搜索
- (void)loadString:(NSString *)str
{
    // 1. URL 定位资源,需要资源的地址
    NSString *urlStr = str;
    NSURL *url = nil;
    
    if ([str hasPrefix:@"http://"] || [str hasPrefix:@"https://"] ){
        url = [NSURL URLWithString:urlStr];

    }else if([str hasPrefix:@"www."] || [str hasPrefix:@"wap."] || [str hasPrefix:@"m."]){
     
        urlStr = [NSString stringWithFormat:@"http://%@", str];
        url = [NSURL URLWithString:urlStr];
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

- (IBAction)clickedBack:(id)sender {
    if ([self.wkWebView canGoBack]) {
        [self.wkWebView goBack];
    }
}

- (IBAction)clickedForward:(id)sender {
    if ([self.wkWebView canGoForward]) {
          [self.wkWebView goForward];
      }
}


- (IBAction)clickedReload:(id)sender {
    [self.wkWebView reload];
}


- (IBAction)clickedHomeRepeat:(id)sender {
//    FSBSetingViewController * vc = [[FSBSetingViewController alloc]init];
    //获取storyboard: 通过bundle根据storyboard的名字来获取我们的storyboard,
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    //由storyboard根据myView的storyBoardID来获取我们要切换的视图
    UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"FSBNavigationController"];
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (IBAction)clickedHome:(id)sender {
    
    NSURL *url = [NSURL URLWithString:TCUserDefaults.shared.getFSBMainPage];
    // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 3. 发送请求给服务器
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
        [UIView animateWithDuration:0.3f animations:^{
            self.searchbarHiddenConstraint.priority = 750;
            if (iPhone_X_S) {
//                self.searchbarTopConstraint.priority = 250;
                self.searchBarToiPhoneXConstraint.priority = 1000;
            } else{
//                self.searchBarToiPhoneXConstraint.priority = 250;
                self.searchbarTopConstraint.priority = 1000;
            }
        }];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            if (iPhone_X_S) {
//                self.searchbarTopConstraint.priority = 250;
                self.searchBarToiPhoneXConstraint.priority = 750;
            } else{
//                self.searchBarToiPhoneXConstraint.priority = 250;
                self.searchbarTopConstraint.priority = 750;
            }
            self.searchbarHiddenConstraint.priority = 1000;
        }];
    }
}



//隐藏搜索框
- (IBAction)srarchButtonHiden:(id)sender {
    
    self.searchBar.hidden = !self.searchBar.hidden;
}


//设置
- (IBAction)setingButton:(id)sender {
    
    FSBSetingViewController * nav = [[FSBSetingViewController alloc]init];
    UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:nav];
    [self.navigationController pushViewController:navi animated:YES];

}


#pragma mark - scrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static float newY = 0;
    newY = scrollView.contentOffset.y;
    
//    NSLog(@"%f", newY);
    
    self.activityView.hidden = YES;

    if (newY != _oldY)
    {
        //向下滚动
        if (newY > _oldY && (newY - _oldY) > 0)
        {

            // 隐藏
            [self searchbarShow:NO];
            [self toolbarShow:NO];
            
            _oldY = newY;
            
        }else if (newY < _oldY && (_oldY - newY) > 100){
            [self.view endEditing:YES];
            
            // 显示
            [self searchbarShow:YES];
            [self toolbarShow:YES];
            
            _oldY = newY;
        }
        
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    // 显示
    [self searchbarShow:YES];
    [self toolbarShow:YES];

    return YES;
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
