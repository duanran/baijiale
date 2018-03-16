//
//  SDKSwitch.m
//  fourGame
//
//  Created by apple on 2018/3/14.
//  Copyright © 2018年 rmbp840. All rights reserved.
//

#import "SDKSwitch.h"

@implementation SDKSwitch

+(instancetype)shareSDKMgr{
    static SDKSwitch *sdk = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sdk = [SDKSwitch new];
    });
    return sdk;
}

-(BOOL)openTheSDK:(id)timer{
    //判断一个固定时间决定是否打开SDK
    self.SDKIsOpen = YES;
    return YES;
}



@end
