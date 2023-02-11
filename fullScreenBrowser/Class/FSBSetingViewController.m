//
//  systemSetingViewController.m
//  fullScreenBrowser
//
//  Created by HTC on 14/12/8.
//  Copyright (c) 2014年 HTC. All rights reserved.
//

#import "FSBSetingViewController.h"
#import <MessageUI/MessageUI.h>
#import "AFNetworking.h"
#import "Utility.h"
#import "sys/utsname.h"
#import "FSB-Swift.h"
#import <SafariServices/SafariServices.h>

@interface FSBSetingViewController ()<MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *mainPageLbl;
@property (weak, nonatomic) IBOutlet UILabel *searchEngineLbl;
@property (weak, nonatomic) IBOutlet UILabel *edgeInsetLbl;
@property (weak, nonatomic) IBOutlet UISwitch *addressSwitchBtn;
@property (weak, nonatomic) IBOutlet UISwitch *passwordSwitchBtn;


@end

@implementation FSBSetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = HTCLocalized(@"Settings");
    
    float top = TCUserDefaults.shared.getFSBEdgeInsetTopValue;
    float left = TCUserDefaults.shared.getFSBEdgeInsetLeftValue;
    float right = TCUserDefaults.shared.getFSBEdgeInsetRightValue;
    float bottom = TCUserDefaults.shared.getFSBEdgeInsetBottomValue;
    
    self.mainPageLbl.text = TCUserDefaults.shared.getFSBMainPage;
    self.searchEngineLbl.text = TCUserDefaults.shared.getFSBSearchPage;
    self.edgeInsetLbl.text = [NSString stringWithFormat:@"(%0.1f, %0.1f, %0.1f, %0.1f)", top, left, right, bottom];
    [self.addressSwitchBtn setOn:TCUserDefaults.shared.getFSBHiddenAddressBar];
    [self.passwordSwitchBtn setOn:TCUserDefaults.shared.getFSBSettingsPasswordStatus];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (IBAction)clickedCloseBtn:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        !self.callback ? : self.callback();
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }];
}

- (IBAction)clickedHiddedAddressSwitch:(UISwitch *)sender {
    [TCUserDefaults.shared setIFSBHiddenAddressBarWithValue:sender.isOn];
}

- (IBAction)clickedSettingsPasswordSwitch:(UISwitch *)sender {
    if (sender.isOn) {
        // 设置密码
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:HTCLocalized(@"Set Password") message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            //textField.secureTextEntry = YES;
            textField.placeholder = HTCLocalized(@"Set Settings Password");
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.keyboardType = UIKeyboardTypeDefault;
            textField.returnKeyType = UIReturnKeyDone;
        }];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:HTCLocalized(@"Settings") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *ps = [[alertController textFields][0] text];
            if (ps.length > 0) {
                [TCUserDefaults.shared setIFSBSettingsPasswordStatusWithValue:YES];
                [TCUserDefaults.shared setIFSBSettingsPasswordWithValue:ps];
                [self.passwordSwitchBtn setOn:TCUserDefaults.shared.getFSBSettingsPasswordStatus];
            } else {
                [self.passwordSwitchBtn setOn:TCUserDefaults.shared.getFSBSettingsPasswordStatus];
                // error
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:HTCLocalized(@"Tips") message:HTCLocalized(@"Password can not be blank") preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:HTCLocalized(@"OK") style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
        [alertController addAction:confirmAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:HTCLocalized(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.passwordSwitchBtn setOn:TCUserDefaults.shared.getFSBSettingsPasswordStatus];
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:HTCLocalized(@"Tips") message:HTCLocalized(@"Delete current password") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:HTCLocalized(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 开关和密码都清空
            [TCUserDefaults.shared setIFSBSettingsPasswordWithValue:@""];
            [TCUserDefaults.shared setIFSBSettingsPasswordStatusWithValue:NO];
            [self.passwordSwitchBtn setOn:NO];
        }];
        [alert addAction:action];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:HTCLocalized(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.passwordSwitchBtn setOn:TCUserDefaults.shared.getFSBSettingsPasswordStatus];
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:{
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:HTCLocalized(@"Set Homepage") message:@"" preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                        textField.placeholder = TCUserDefaults.shared.getFSBMainPage;
                        textField.text = TCUserDefaults.shared.getFSBMainPage;
                        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                        textField.keyboardType = UIKeyboardTypeURL;
                        textField.returnKeyType = UIReturnKeyDone;
                    }];
                    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:HTCLocalized(@"Settings") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        //compare the current password and do action here
                        [TCUserDefaults.shared setIFSBMainPageWithValue:[[alertController textFields][0] text]];
                        self.mainPageLbl.text = TCUserDefaults.shared.getFSBMainPage;

                    }];
                    [alertController addAction:confirmAction];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:HTCLocalized(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    }];
                    [alertController addAction:cancelAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                    break;
                }
                case 1:{
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:HTCLocalized(@"Set Search Engine") message:@"" preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                        textField.placeholder = TCUserDefaults.shared.getFSBSearchPage;
                        textField.text = TCUserDefaults.shared.getFSBSearchPage;
                        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                        textField.keyboardType = UIKeyboardTypeURL;
                        textField.returnKeyType = UIReturnKeyDone;
                    }];
                    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:HTCLocalized(@"Custom Search Engine") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        NSString *url = [[alertController textFields][0] text];
                        [TCUserDefaults.shared setIFSBSrarchPageWithValue:url];
                        self.searchEngineLbl.text = url;
                    }];
                    [alertController addAction:confirmAction];
                    UIAlertAction *confirmAction1 = [UIAlertAction actionWithTitle:HTCLocalized(@"Bing") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSString *url = @"https://www.bing.com/search?q=";
                        [self saveSearchEngineURL:url];
                    }];
                    [alertController addAction:confirmAction1];
                    UIAlertAction *confirmAction2 = [UIAlertAction actionWithTitle:HTCLocalized(@"Google") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSString *url = @"https://www.google.com/search?q=";
                        [self saveSearchEngineURL:url];
                    }];
                    [alertController addAction:confirmAction2];
                    UIAlertAction *confirmAction3 = [UIAlertAction actionWithTitle:HTCLocalized(@"Baidu") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSString *url = @"https://www.baidu.com/s?wd=";
                        [self saveSearchEngineURL:url];
                    }];
                    [alertController addAction:confirmAction3];
                    UIAlertAction *confirmAction7 = [UIAlertAction actionWithTitle:HTCLocalized(@"Sogou") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSString *url = @"https://www.sogou.com/web?query=";
                        [self saveSearchEngineURL:url];
                    }];
                    [alertController addAction:confirmAction7];
                    UIAlertAction *confirmAction8 = [UIAlertAction actionWithTitle:HTCLocalized(@"360") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSString *url = @"https://www.so.com/s?q=";
                        [self saveSearchEngineURL:url];
                    }];
                    [alertController addAction:confirmAction8];
                    UIAlertAction *confirmAction4 = [UIAlertAction actionWithTitle:HTCLocalized(@"DuckDuckGo") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSString *url = @"https://duckduckgo.com/?q=";
                        [self saveSearchEngineURL:url];
                    }];
                    [alertController addAction:confirmAction4];
                    UIAlertAction *confirmAction5 = [UIAlertAction actionWithTitle:HTCLocalized(@"GitHub") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSString *url = @"https://github.com/search?q=";
                        [self saveSearchEngineURL:url];
                    }];
                    [alertController addAction:confirmAction5];
                    UIAlertAction *confirmAction6 = [UIAlertAction actionWithTitle:HTCLocalized(@"StackOverflow") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSString *url = @"https://www.stackoverflow.com/search?q=";
                        [self saveSearchEngineURL:url];
                    }];
                    [alertController addAction:confirmAction6];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:HTCLocalized(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    }];
                    [alertController addAction:cancelAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                    break;
                }
                case 2: {
                    // 设置边距
                    float top = TCUserDefaults.shared.getFSBEdgeInsetTopValue;
                    float left = TCUserDefaults.shared.getFSBEdgeInsetLeftValue;
                    float right = TCUserDefaults.shared.getFSBEdgeInsetRightValue;
                    float bottom = TCUserDefaults.shared.getFSBEdgeInsetBottomValue;
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:HTCLocalized(@"Set Browser Margins") message:HTCLocalized(@"Set Browser Margins Tips") preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                        textField.placeholder = HTCLocalized(@"Set Browser Margins Top");
                        textField.text = [NSString stringWithFormat:@"%0.1f", top];
                        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                        textField.keyboardType = UIKeyboardTypeURL;
                        textField.returnKeyType = UIReturnKeyDone;
                    }];
                    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                        textField.placeholder = HTCLocalized(@"Set Browser Margins Left");
                        textField.text = [NSString stringWithFormat:@"%0.1f", left];
                        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                        textField.keyboardType = UIKeyboardTypeURL;
                        textField.returnKeyType = UIReturnKeyDone;
                    }];
                    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                        textField.placeholder = HTCLocalized(@"Set Browser Margins Right");
                        textField.text = [NSString stringWithFormat:@"%0.1f", right];
                        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                        textField.keyboardType = UIKeyboardTypeURL;
                        textField.returnKeyType = UIReturnKeyDone;
                    }];
                    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                        textField.placeholder = HTCLocalized(@"Set Browser Margins Bottom");
                        textField.text = [NSString stringWithFormat:@"%0.1f", bottom];
                        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                        textField.keyboardType = UIKeyboardTypeURL;
                        textField.returnKeyType = UIReturnKeyDone;
                    }];
                    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:HTCLocalized(@"Settings") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        //compare the current password and do action here
                        float top = [[[alertController textFields][0] text] floatValue];
                        float left = [[[alertController textFields][1] text] floatValue];
                        float right = [[[alertController textFields][2] text] floatValue];
                        float bottom = [[[alertController textFields][3] text] floatValue];
                        [TCUserDefaults.shared setIFSBEdgeInsetTopWithValue:top];
                        [TCUserDefaults.shared setIFSBEdgeInsetLeftWithValue:left];
                        [TCUserDefaults.shared setIFSBEdgeInsetRightWithValue:right];
                        [TCUserDefaults.shared setIFSBEdgeInsetBottomWithValue:bottom];
                        self.edgeInsetLbl.text = [NSString stringWithFormat:@"(%0.1f, %0.1f, %0.1f, %0.1f)", top, left, right, bottom];
                    }];
                    [alertController addAction:confirmAction];
                    UIAlertAction *resetAction = [UIAlertAction actionWithTitle:HTCLocalized(@"Reset Default") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [TCUserDefaults.shared setIFSBEdgeInsetTopWithValue:0.0];
                        [TCUserDefaults.shared setIFSBEdgeInsetLeftWithValue:0.0];
                        [TCUserDefaults.shared setIFSBEdgeInsetRightWithValue:0.0];
                        [TCUserDefaults.shared setIFSBEdgeInsetBottomWithValue:0.0];
                        self.edgeInsetLbl.text = @"(0.0, 0.0, 0.0, 0.0)";
                    }];
                    [alertController addAction:resetAction];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:HTCLocalized(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    }];
                    [alertController addAction:cancelAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                    break;
                }
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:{
                    struct utsname systemInfo;
                    uname(&systemInfo);
                    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
                    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                    [self sendEmailWithSubject:HTCLocalized(@"Full screen browser feedback") MessageBody:[NSString stringWithFormat:@"%@v%@，%@：%@,iOSv%@\n%@：\n1、\n2、\n3、", HTCLocalized(@"I am using a full-screen browser now"), HTCLocalized(@"Use Device"), HTCLocalized(@"My feedback and suggestions"), [infoDictionary objectForKey:@"CFBundleShortVersionString"], platform, [[UIDevice currentDevice] systemVersion]] isHTML:NO toRecipients:@[@"iHTCdevelop@gmail.com"] ccRecipients:nil bccRecipients:nil  Image:nil imageQuality:0];
                    break;
                }
                case 2:
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://apps.apple.com/cn/app/iBrower/id948944368"] options:@{} completionHandler:nil];
                    break;
                default:
                    break;
            }
        
        }
        break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:{
                    [self inSafariOpenWithURL:@"https://raw.githubusercontent.com/iHTCboy/FullScreenBrowser/master/LICENSE"];
                    break;
                }
                case 1:{
                    ITAdvancelDetailViewController *vc = [[ITAdvancelDetailViewController alloc] init];
                    vc.title = HTCLocalized(@"More recommendations");
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
            }
        }
            break;
            
        default:
            break;
    }
}


- (void)saveSearchEngineURL:(NSString *)url {
    [TCUserDefaults.shared setIFSBSrarchPageWithValue:url];
    self.searchEngineLbl.text = url;
}

/**
 *  从Safari打开
 */
- (void)inSafariOpenWithURL:(NSString *)url
{
    SFSafariViewController * sf = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url]];
    if (@available(iOS 11.0, *)) {
        sf.preferredBarTintColor = [UIColor colorWithRed:(66)/255.0 green:(156)/255.0 blue:(249)/255.0 alpha:1];
        sf.dismissButtonStyle = SFSafariViewControllerDismissButtonStyleClose;
        sf.preferredControlTintColor = [UIColor whiteColor];
    }
    [self presentViewController:sf animated:YES completion:nil];
}


/**
 *  发送邮件
 */
- (void)sendEmailWithSubject:(NSString *)subject MessageBody:(NSString *)MessageBody isHTML:(BOOL)isHTML toRecipients:(NSArray *)recipients  ccRecipients:(NSArray *)ccRecipients bccRecipients:(NSArray *)bccRecipients Image:(UIImage *)image imageQuality:(CGFloat)quality
{
    
    // 不能发邮件
    if (![MFMailComposeViewController canSendMail]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:HTCLocalized(@"Tips") message:HTCLocalized(@"Does not support sending mail") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:HTCLocalized(@"OK") style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
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


#pragma mark - status bar
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
@end
