//
//  DetailVC.m
//  fourGame
//
//  Created by rmbp840 on 17/4/3.
//  Copyright © 2017年 rmbp840. All rights reserved.
//

#import "DetailVC.h"
#import "CCTapped.h"
@interface DetailVC ()
@property (weak, nonatomic) IBOutlet UIImageView *closeImg;

@end

@implementation DetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [_closeImg whenTapped:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
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
