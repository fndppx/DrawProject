//
//  QCAPIConfig.h
//  QingClass
//
//  Created by 0dayZh on 2017/1/11.
//  Copyright © 2017年 qingclass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QCAPIDefines.h"

extern NSString * const BaseURLString;

@interface QCAPIConfig : NSObject

@property (nonatomic, strong, readonly) NSURL *baseURL;
@property (nonatomic, strong, readonly) NSString  *wilddogBaseURLString;
@property (nonatomic, strong, readonly) NSString  *versionkeyString;
@property (nonatomic, strong, readonly) NSString  *rongCloudAppkeyString;

+ (instancetype)defaultConfig;      // dev when defined DEBUG, distribution in other situation
+ (instancetype)distributionConfig;
+ (instancetype)devConfig;
+ (instancetype)testConfig;
+ (instancetype)configWithBaseURL:(NSURL *)baseURL versionkeyString:(NSString *)vkString;
- (BOOL)isEqualToConfig:(QCAPIConfig *)object;

@end
