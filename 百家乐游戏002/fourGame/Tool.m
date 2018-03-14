//
//  Tool.m
//  card
//
//  Created by rmbp840 on 17/3/4.
//  Copyright © 2017年 rmbp840. All rights reserved.
//

#import "Tool.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#ifndef __OPTIMIZE__
#define NSLog(...) printf("%f %s\n",[[NSDate date]timeIntervalSince1970],[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);
#endif

static SystemSoundID shake_sound_male_id = 0;
@implementation Tool

+ (void)play:(NSString *)name{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"wav"];
    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:path]),&shake_sound_male_id);
        AudioServicesPlaySystemSound(shake_sound_male_id);
                AudioServicesPlaySystemSound(shake_sound_male_id);//如果无法再下面播放，可以尝试在此播放
    }
    
    AudioServicesPlaySystemSound(shake_sound_male_id);   //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
    
    //    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
}
@end
