//
//  ViewController.m
//  fullScreenBrowser
//
//  Created by HTC on 14/12/1.
//  Copyright (c) 2014年 HTC. All rights reserved.
//

#import "RootViewController.h"
#import "FSBSetingViewController.h"

#import "BaiduMobStat.h"

#define topHight (iPhone_X_S ? 44 : 0)
#define indcatorHight (iPhone_X_S ? 34 : 0)
#define navBarHight (iPhone_X_S ? 68 : 44)
#define iPhone_X_S ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone && ([UIScreen mainScreen].bounds.size.height == 812.0 || [UIScreen mainScreen].bounds.size.height == 896.0))

@interface RootViewController ()<UISearchBarDelegate,UIWebViewDelegate,UIScrollViewDelegate>

@property (nonatomic, assign) float oldY;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.searchBar.delegate = self;
    self.uiWebView.delegate = self;
    self.uiWebView.scrollView.delegate = self;
    
    //self.searchBar.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.700];
    self.searchBar.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.850];
    self.searchBar.tintColor = [UIColor colorWithRed:0.0/255 green:185.0/255 blue:253.0/255 alpha:1];
    self.searchBar.barTintColor = [UIColor colorWithRed:0.0/255 green:185.0/255 blue:253.0/255 alpha:1];
    //self.searchBar.showsCancelButton = YES;
    
    self.uiWebView.backgroundColor = [UIColor whiteColor];
    self.uiWebView.scalesPageToFit = YES;
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
    
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 3. 发送请求给服务器
    [self.uiWebView loadRequest:request];
    
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    
    if (![df boolForKey:@"TheUserTermsAndConditions"]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"用户条款" message:@"如果继续使用，则表示你同意本应用的协议。" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"同意协议" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [df setBool:YES forKey:@"TheUserTermsAndConditions"];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"查看协议" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self loadString:@"https://raw.githubusercontent.com/iHTCboy/FullScreenBrowser/master/LICENSE"];
        }];
        
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self presentViewController:alert animated:YES completion:nil];
        });
    }
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
        urlStr = [NSString stringWithFormat:@"https://www.baidu.com/s?wd=%@", str];
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        url = [NSURL URLWithString:urlStr];
    }
    
    // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 3. 发送请求给服务器
    [self.uiWebView loadRequest:request];
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
-(void)webViewDidStartLoad:(UIWebView *)webView{
    self.activityView.hidden = NO;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    self.activityView.hidden = YES;
}

#pragma mark 完成加载
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 根据webView当前的状态,来判断按钮的状态
    self.backButton.enabled = webView.canGoBack;
    self.forwarButton.enabled = webView.canGoForward;
    
    self.activityView.hidden = YES;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //NSLog(@"request-----%@",request);
    self.searchBar.text = [NSString stringWithFormat:@"%@",request.URL];
    // 实现WebView的代理方法，并在此函数中调用SDK的webviewStartLoadWithRequest:传入request参数，进行统计
    [[BaiduMobStat defaultStat] webviewStartLoadWithRequest:request];
    return YES;
}

#pragma mark TabBar栏事件
- (IBAction)clickedHomeRepeat:(id)sender {
//    FSBSetingViewController * vc = [[FSBSetingViewController alloc]init];
    //获取storyboard: 通过bundle根据storyboard的名字来获取我们的storyboard,
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    //由storyboard根据myView的storyBoardID来获取我们要切换的视图
    UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"FSBNavigationController"];
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (IBAction)clickedHome:(id)sender {
    
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 3. 发送请求给服务器
    [self.uiWebView loadRequest:request];
}

- (IBAction)toFullScreen:(id)sender {
    
    // 隐藏状态栏
//    [UIApplication sharedApplication].statusBarHidden = YES;
    
    CGRect webFrame = self.uiWebView.frame;
    webFrame.size.height = self.view.frame.size.height;
    
    CGRect toolbarsFrame = self.toolbars.frame;
    toolbarsFrame.origin.y = self.view.frame.size.height + navBarHight;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.uiWebView.frame = webFrame;
        self.toolbars.frame = toolbarsFrame;
    }];
    
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

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    static float newY = 0;
    newY = scrollView.contentOffset.y;
    
    self.activityView.hidden = YES;

    if (newY != _oldY)
    {
        //向下滚动
        if (newY > _oldY && (newY - _oldY) > 0)
        {

            // 隐藏状态栏
//            [UIApplication sharedApplication].statusBarHidden = YES;
            CGRect searchFrame = self.searchBar.frame;
            searchFrame.origin.y = -navBarHight;
            
            CGRect webFrame = self.uiWebView.frame;
            webFrame.size.height = self.view.frame.size.height;
    
            CGRect toolbarsFrame = self.toolbars.frame;
            toolbarsFrame.origin.y = self.view.frame.size.height + navBarHight;
            
            [UIView animateWithDuration:0.3f animations:^{
                self.searchBar.frame = searchFrame;
                self.uiWebView.frame = webFrame;
                self.toolbars.frame = toolbarsFrame;
            }];
            
            _oldY = newY;
            
        }else if (newY < _oldY && (_oldY - newY) > 100){
            [self.view endEditing:YES];
            
            // 显示状态栏
//            [UIApplication sharedApplication].statusBarHidden = NO;
            
            CGRect searchFrame = self.searchBar.frame;
            searchFrame.origin.y = topHight;
            
            CGRect webFrame = self.uiWebView.frame;
            //webFrame.origin.y  = 0;
            webFrame.size.height = self.view.frame.size.height -navBarHight;
            
            CGRect toolbarsFrame = self.toolbars.frame;
            toolbarsFrame.origin.y = self.view.frame.size.height -navBarHight;
            
            [UIView animateWithDuration:0.3f animations:^{
                self.searchBar.frame = searchFrame;
                self.uiWebView.frame = webFrame;
                self.toolbars.frame = toolbarsFrame;
            }];
            
            _oldY = newY;
        }
        
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    
    CGRect searchFrame = self.searchBar.frame;
    searchFrame.origin.y = topHight;
    
    CGRect webFrame = self.uiWebView.frame;
    //webFrame.origin.y  = 0;
    webFrame.size.height = self.view.frame.size.height -navBarHight;
    
    CGRect toolbarsFrame = self.toolbars.frame;
    toolbarsFrame.origin.y = self.view.frame.size.height -navBarHight;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.searchBar.frame = searchFrame;
        self.uiWebView.frame = webFrame;
        self.toolbars.frame = toolbarsFrame;

    }];

    return YES;
}


@end
