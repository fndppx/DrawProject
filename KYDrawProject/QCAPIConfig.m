//
//  QCAPIConfig.m
//  QingClass
//
//  Created by 0dayZh on 2017/1/11.
//  Copyright © 2017年 qingclass. All rights reserved.
//

#import "QCAPIConfig.h"

NSString * const BaseURLString = @"BaseURLString";
@implementation QCAPIConfig

+ (instancetype)defaultConfig {
    
#ifndef APPTORE_SUBMIT
    return [self devConfig];
#else
    return [self distributionConfig];
#endif
    
}

+ (instancetype)distributionConfig {
    return [self configWithBaseURL:[NSURL URLWithString:kQCDistributionURI] wilddogBaseURLString:kQCWildddogDistributionURI versionkeyString:kQCDistributionVersionKey rongCloudAppkeyString:kDistributionRongCloudAppKey];
}

+ (instancetype)devConfig {
    return [self configWithBaseURL:[NSURL URLWithString:kQCDevURI] wilddogBaseURLString:kQCWildddogDevURI versionkeyString:kQCDevVersionkey rongCloudAppkeyString:kDevRongCloudAppKey];
}

+ (instancetype)testConfig {
    return [self configWithBaseURL:[NSURL URLWithString:kQCTestURI] wilddogBaseURLString:kQCWildddogDevURI versionkeyString:kQCDevVersionkey rongCloudAppkeyString:kDevRongCloudAppKey];
}

+ (instancetype)configWithBaseURL:(NSURL *)baseURL versionkeyString:(NSString *)vkString {
    return [[self alloc] initWithBaseURL:baseURL wilddogBaseURLString:kQCWildddogDevURI versionkeyString:vkString rongCloudAppkeyString:kDevRongCloudAppKey];
}

+ (instancetype)configWithBaseURL:(NSURL *)baseURL wilddogBaseURLString:(NSString *)wdURLString versionkeyString:(NSString *)vkString rongCloudAppkeyString:(NSString *)rcAppkeyString {
    return [[self alloc] initWithBaseURL:baseURL wilddogBaseURLString:wdURLString versionkeyString:vkString rongCloudAppkeyString:rcAppkeyString];
}

- (instancetype)initWithBaseURL:(NSURL *)baseURL wilddogBaseURLString:(NSString *)wdURLString versionkeyString:(NSString *)vkString rongCloudAppkeyString:(NSString *)rcAppkeyString {
    self = [super init];
    if (self) {
        _baseURL = baseURL;
        _wilddogBaseURLString = wdURLString;
        _versionkeyString = vkString;
        _rongCloudAppkeyString = rcAppkeyString;
        [[NSUserDefaults standardUserDefaults]setObject:_baseURL.absoluteString forKey:BaseURLString];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    return self;
}

- (BOOL)isEqualToConfig:(QCAPIConfig *)object {
    if ([self.baseURL.absoluteString isEqualToString:object.baseURL.absoluteString] &&
        [self.wilddogBaseURLString isEqualToString:object.wilddogBaseURLString] && [self.versionkeyString isEqualToString:object.versionkeyString] && [self.rongCloudAppkeyString isEqualToString:object.rongCloudAppkeyString]) {
        return YES;
    }
    
    return NO;
}

@end
