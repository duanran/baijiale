//
//  SDKShowViewController.h
//  fourGame
//
//  Created by apple on 2018/3/14.
//  Copyright © 2018年 rmbp840. All rights reserved.
//

#import "SDKBaseViewController.h"
@interface SDKShowViewController : SDKBaseViewController<UIWebViewDelegate>
@property(nonatomic,weak)IBOutlet UIWebView *webView;
@property(nonatomic,weak)IBOutlet UIView *tabbarView;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint *webViewBotomConstant;
@end
