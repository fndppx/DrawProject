


//
//  QCModel.m
//  KYDrawProject
//
//  Created by 魏柯岩 on 2017/11/2.
//  Copyright © 2017年 mengmengda. All rights reserved.
//

#import "QCModel.h"
@implementation QCModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"appid": @"appid",
             @"appname":@"appname",
             @"desc": @"desc",
             @"isshowwap":@"isshowwap",
             @"wapurl": @"wapurl",
             @"status": @"status",
             };
}
@end
