//
//  QCAPIManager.m
//  QingClass
//
//  Created by 0dayZh on 2016/11/18.
//  Copyright © 2016年 qingclass. All rights reserved.
//

#import "QCAPIManager.h"
#import <AFNetworking/AFNetworking.h>
#import "QCModel.h"
@interface QCAPIManager ()

@property (nonatomic, strong) AFHTTPSessionManager  *sessionManager;

@end

@implementation QCAPIManager

+ (instancetype)sharedManager {
    static QCAPIManager *s_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_manager = [[self alloc] init];
    });
    
    return s_manager;
}

- (void)setupConfig:(QCAPIConfig *)config {
    if ([_config isEqualToConfig:config]) {
        return;
    }
    
    _config = config;
    
    _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:config.baseURL];
    _sessionManager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
//    [_sessionManager.requestSerializer setValue:config.versionkeyString forHTTPHeaderField:@"x-version-key"];
//    [_sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [_sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [_sessionManager.requestSerializer setValue:@"text/javascript" forHTTPHeaderField:@"Content-Type"];
//
//    @"text/json", @"text/javascript"
    _sessionManager.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    _sessionManager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    _sessionManager.requestSerializer.timeoutInterval = 10;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupConfig:[QCAPIConfig defaultConfig]];

    }
    
    return self;
}

- (void)logout {
    self.sessionID = nil;
}

- (void)setSessionID:(NSString *)sessionID {
    if ([_sessionID isEqualToString:sessionID]) {
        return;
    }
    
    _sessionID = sessionID;
    if (sessionID && sessionID.length > 0) {
        [_sessionManager.requestSerializer setValue:sessionID forHTTPHeaderField:@"x-session-token"];
    } else {
        [_sessionManager.requestSerializer setValue:nil forHTTPHeaderField:@"x-session-token"];
    }
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(id)parameters
                               success:(void (^)(NSURLSessionDataTask *task, id _responseObject))success
                               failure:(void (^)(NSURLSessionDataTask * _task, NSError *error))failure {
    QCLog(@"GET: %@, headers: %@", URLString, self.sessionManager.requestSerializer.HTTPRequestHeaders);
    return [self.sessionManager GET:URLString
                         parameters:parameters
                           progress:nil
                            success:success
                            failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id _responseObject))success
                       failure:(void (^)(NSURLSessionDataTask * _task, NSError *error))failure {
    return [self.sessionManager POST:URLString
                          parameters:parameters
                            progress:nil
                             success:success
                             failure:failure];
}

- (BOOL)isStatusMatch:(NSString *)status object:(id)responseObject {
    NSInteger ss = [responseObject[@"status"] integerValue];
    NSInteger statusInt = [status integerValue];
    if (responseObject[@"status"]) {
        if (ss == statusInt) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

- (void)filtraterHttpErrorCode:(NSInteger)code error:(NSError **)error errorDomain:(NSString*)errorDomain{
    QCAPIHTTPErrorCode httpErrorCode = QCAPIHTTPErrorCodeResourceNotFound;
    NSString * errorTip = @"";
    NSInteger status = code;
    switch (status) {
        case 400:
            httpErrorCode = QCAPIHTTPErrorCodeRequestFailure;
            errorTip = @"请求参数异常";
            break;
        case 404:
            httpErrorCode = QCAPIHTTPErrorCodeResourceNotFound;
            errorTip = @"URL资源不存在";
            break;
        case 500:
            httpErrorCode = QCAPIHTTPErrorCodeServerError;
            errorTip = @"服务器开小差";
            break;
        case 443:
            httpErrorCode = QCAPIHTTPErrorCodeServerError;
            errorTip = @"用户登录失效，请重新登录";
//            [[QCUserManager sharedManager]logout];
            break;
        default:
            httpErrorCode = QCAPIHTTPErrorCodeServerUnkonwError;
            errorTip = @"请求失败,请稍后重试";
            break;
    }
    
    *error = [NSError errorWithDomain:errorDomain
                                 code:httpErrorCode
                             userInfo:@{NSLocalizedDescriptionKey: errorTip}];
    
}
- (BOOL)verifyReponseObjectV2:(id)responseObject error:(NSError **)error errorDomain:(NSString*)errorDomain {
    if (![responseObject isKindOfClass:[NSDictionary class]]) {
        *error = [NSError errorWithDomain:errorDomain
                                     code:QCAPIStatusCodeUnknow
                                 userInfo:@{NSLocalizedFailureReasonErrorKey: @"unknow"}];
        return NO;
    }
    
    if (!responseObject[@"status"]) {
        *error = [NSError errorWithDomain:errorDomain
                                     code:QCAPIStatusCodeUnknow
                                 userInfo:@{NSLocalizedFailureReasonErrorKey: @"unknow"}];
        return NO;
    }
    
    QCAPIStatusCode statusCode = QCAPIStatusCodeUnknow;
    NSString *failureReason = responseObject[@"message"];
    NSInteger status = [responseObject[@"status"] integerValue];
    switch (status) {
        case 0:
            statusCode = QCAPIStatusCodeOK;
            break;
        case 1:
            statusCode = QCAPIStatusCodeError;
            break;
        case 2:
            statusCode = QCAPIStatusCodeForbidLogin;
            break;
      
        default:
            statusCode = QCAPIStatusCodeUnknow;
            break;
    }
    
    if (QCAPIStatusCodeOK != statusCode) {
        if (failureReason.length == 0) {
            failureReason = @"请求失败,请稍后重试";
        }
        *error = [NSError errorWithDomain:errorDomain code:statusCode userInfo:@{NSLocalizedDescriptionKey: failureReason}];
        
        if (QCAPIStatusCodeForbidLogin == statusCode) {
//            [[QCUserManager sharedManager] logout];
        }
        
        return NO;
    }
    
    return YES;
}

- (void)getInfoSuccess:(void (^)(QCModel *model))success
                   failure:(void (^)(NSError *error))failure {
    [self GET:@"/frontApi/getAboutUs?appid=111"
   parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          QCLog(@"%@ %@", NSStringFromSelector(_cmd), responseObject);
          NSError *error = nil;
          if ([[responseObject objectForKey:@"status"] integerValue]==0) {
              QCModel * model = [QCModel mj_objectWithKeyValues:responseObject];
              !success?:success(model);

          }else{
              !failure ?: failure(error);

          }
    
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          QCLog(@"%@", error);
          !failure ?: failure(error);
      }];
}



@end

NSString * const dataKey = @"data";
NSString * const statusKey = @"status";
NSString * const messagesKey = @"message";
