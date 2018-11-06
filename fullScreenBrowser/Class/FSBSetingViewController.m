//
//  systemSetingViewController.m
//  fullScreenBrowser
//
//  Created by HTC on 14/12/8.
//  Copyright (c) 2014年 HTC. All rights reserved.
//

#import "FSBSetingViewController.h"
#import <MessageUI/MessageUI.h>
#import "FSBGirlCollectionVC.h"
#import "AFNetworking.h"
#import "sys/utsname.h"
#import <SafariServices/SafariServices.h>

@interface FSBSetingViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation FSBSetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}


- (IBAction)clickedCloseBtn:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:{
                    struct utsname systemInfo;
                    uname(&systemInfo);
                    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
                    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                    [self sendEmailWithSubject:@"@全屏浏览器的反馈" MessageBody:[NSString stringWithFormat:@"我现在使用全屏浏览器v%@,使用设备：%@,iOSv%@\n我的反馈和建议：\n1、\n2、\n3、",[infoDictionary objectForKey:@"CFBundleShortVersionString"],platform,[[UIDevice currentDevice] systemVersion]] isHTML:NO toRecipients:@[@"ihetiancong@qq.com"] ccRecipients:nil bccRecipients:nil  Image:nil imageQuality:0];
                    break;
                }
                case 2:
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",@"948944368"]]];
                    break;
                    
                default:
                    break;
            }
        
        }
        break;
        case 1:
        {
            [self inSafariOpenWithURL:@"https://raw.githubusercontent.com/iHTCboy/FullScreenBrowser/master/LICENSE"];
//            FSBGirlCollectionVC * vc = [[FSBGirlCollectionVC alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}


/**
 *  从Safari打开
 */
- (void)inSafariOpenWithURL:(NSString *)url
{
    if (@available(iOS 9.0, *)) {
        SFSafariViewController * sf = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url]];
        if (@available(iOS 11.0, *)) {
            sf.preferredBarTintColor = [UIColor colorWithRed:(66)/255.0 green:(156)/255.0 blue:(249)/255.0 alpha:1];
            sf.dismissButtonStyle = SFSafariViewControllerDismissButtonStyleClose;
        }
        [self presentViewController:sf animated:YES completion:nil];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}


/**
 *  发送邮件
 */
- (void)sendEmailWithSubject:(NSString *)subject MessageBody:(NSString *)MessageBody isHTML:(BOOL)isHTML toRecipients:(NSArray *)recipients  ccRecipients:(NSArray *)ccRecipients bccRecipients:(NSArray *)bccRecipients Image:(UIImage *)image imageQuality:(CGFloat)quality
{
    
    // 不能发邮件
    if (![MFMailComposeViewController canSendMail]) return;
    
    MFMailComposeViewController *email = [[MFMailComposeViewController alloc] init];
    
    // 设置邮件主题
    [email setSubject:subject];
    // 设置邮件内容
    [email setMessageBody:MessageBody isHTML:isHTML];
    // 设置收件人列表
    [email setToRecipients:recipients];
    // 设置抄送人列表
    [email setCcRecipients:ccRecipients];
    // 设置密送人列表
    [email setBccRecipients:bccRecipients];
    
    // 添加附件（一张图片）
    if (image)
    {
        NSData *data = UIImageJPEGRepresentation(image, quality);
        [email addAttachmentData:data mimeType:@"image/jepg" fileName:@"image.jpeg"];
    }
    
    // 设置代理
    email.mailComposeDelegate = self;
    // 显示控制器
    [self presentViewController:email animated:YES completion:nil];
    
}

/**
 *  邮件发送后的代理方法回调，发完后会自动回到原应用
 */
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    // 关闭邮件界面
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
