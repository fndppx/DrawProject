//
//  QCAPIManager.h
//  QingClass
//
//  Created by 0dayZh on 2016/11/18.
//  Copyright © 2016年 qingclass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QCAPIConfig.h"
#import "QCModel.h"
typedef NS_ENUM(NSInteger, QCAPIStatusCode) {
    QCAPIStatusCodeUnknow = -1,
    QCAPIStatusCodeOK = 0,
    QCAPIStatusCodeError = 1,
    QCAPIStatusCodeForbidLogin = 2, //禁止登录
};


typedef NS_ENUM(NSInteger, QCAPIHTTPErrorCode) {
    QCAPIHTTPErrorCodeRequestFailure = 400,//请求参数异常 客户端调试
    QCAPIHTTPErrorCodeResourceNotFound = 404,//URL资源不存在
    QCAPIHTTPErrorCodeServerError = 500,//服务器开小差
    QCAPIHTTPErrorCodeNetworkNotConnectedError = -1009,//网络连接失败
    QCAPIHTTPErrorCodeServerUnkonwError = -2,//未知错误
};

extern NSString * const dataKey;
extern NSString * const statusKey;
extern NSString * const messagesKey;

@interface QCAPIManager : NSObject

@property (nonatomic, strong) NSString  *sessionID;
@property (nonatomic, strong, readonly) QCAPIConfig   *config;
@property (nonatomic, strong) QCModel  *modelItem;

+ (instancetype)sharedManager;
- (void)setupConfig:(QCAPIConfig *)config;

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id _responseObject))success
                      failure:(void (^)(NSURLSessionDataTask * _task, NSError *error))failure;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id _responseObject))success
                       failure:(void (^)(NSURLSessionDataTask * _task, NSError *error))failure;

- (BOOL)isStatusMatch:(NSString *)status object:(id)responseObject;
- (void)filtraterHttpErrorCode:(NSInteger)code error:(NSError **)error errorDomain:(NSString*)errorDomain;
- (BOOL)verifyReponseObjectV2:(id)responseObject error:(NSError **)error errorDomain:(NSString*)errorDomain;

- (void)getInfoSuccess:(void (^)(QCModel *model))success
               failure:(void (^)(NSError *error))failure;
@end
