//
//  QCGuideViewController.h
//  QingClass
//
//  Created by 0dayZh on 2017/1/6.
//  Copyright © 2017年 qingclass. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCGuideViewController : UIViewController

+ (void)showGuideViewControllerIfNeededInWindow:(UIWindow *)window done:(void (^)(void))handler;
+ (BOOL)shouldShowGuideViewController;

@end
