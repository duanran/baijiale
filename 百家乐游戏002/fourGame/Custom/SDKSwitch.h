//
//  SDKSwitch.h
//  fourGame
//
//  Created by apple on 2018/3/14.
//  Copyright © 2018年 rmbp840. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDKSwitch : NSObject
@property(nonatomic,assign)BOOL SDKIsOpen;
+(instancetype)shareSDKMgr;
-(BOOL)openTheSDK:(id)timer;
@end
