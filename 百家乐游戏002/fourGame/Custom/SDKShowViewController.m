//
//  SDKShowViewController.m
//  fourGame
//
//  Created by apple on 2018/3/14.
//  Copyright © 2018年 rmbp840. All rights reserved.
//

#import "SDKShowViewController.h"
#import "Macros.h"
#import "MBProgressHUD.h"
@interface SDKShowViewController ()

@end

@implementation SDKShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:BASEURL]]];
    self.webView.delegate = self;


    // Do any additional setup after loading the view from its nib.
}



-(IBAction)clickBotomBtn:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if (self.webView) {
        switch (btn.tag) {
            case 0:
                NSLog(@"点击首页");
                [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:BASEURL]]];
                break;
            case 1:
                NSLog(@"点击后退");
                [self.webView goBack];
                break;
                
            case 2:
                [self.webView goForward];
                NSLog(@"点击前进");
                break;
            case 3:
                [self.webView reload];
                NSLog(@"点击刷新");
                break;
            case 4:
                NSLog(@"点击退出");
                [self dismissViewControllerAnimated:YES completion:nil];
                break;
                
            default:
                break;
        }
    }
    else{
        NSLog(@"当前webView位空");
    }
    

}


#pragma mark-webViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的网络无法连接，请稍后重试" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"我知道了", nil];
        [alert show];
    }

}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    NSLog(@"调整tabbarview");
    [self adjustSDKTabbar];

}
-(void)adjustSDKTabbar
{
    if ([self isLandscape]) {
        NSLog(@"横屏隐藏tabbar");
        self.tabbarView.hidden = YES;
        self.webViewBotomConstant.constant = 0;
    }
    else{
        NSLog(@"竖屏展示tabbar");
        self.tabbarView.hidden = NO;
        self.webViewBotomConstant.constant = -50;
    }
}
-(BOOL)isLandscape
{
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
        return YES;
    }
    else
    {
        return NO;
    }
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
