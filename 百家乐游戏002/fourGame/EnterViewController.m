//
//  EnterViewController.m
//  YYEKT
//
//  Created by 杨闻晓 on 2017/6/16.
//  Copyright © 2017年 lin. All rights reserved.
//

#import "EnterViewController.h"
#import "GameVC.h"
@interface EnterViewController ()
- (IBAction)EnterGameBtnClick:(id)sender;

@end

@implementation EnterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeRight;
}
- (BOOL)shouldAutorotate
{
    return YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return  [self supportedInterfaceOrientations];
//    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}
- (IBAction)EnterGameBtnClick:(id)sender {
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:[[GameVC alloc] init] animated:YES completion:nil];
}
@end
