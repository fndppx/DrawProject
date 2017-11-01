//
//  QCAPIDefines.h
//  QingClass
//
//  Created by SXJH on 2017/8/31.
//  Copyright © 2017年 qingclass. All rights reserved.
//

#ifndef QCAPIDefines_h
#define QCAPIDefines_h

//#define APPTORE_SUBMIT  // 提交appstore打开
//水星：mercury -> 开发环境 -> app-mercury.qingclass.com
//金星：venus -> 测试环境 -> app-venus.qingclass.com
//火星：mars -> 压力测试环境 -> app-mars.qingclass.com
//木星：jupiter -> 预生产环境 -> app-jupiter.qingclass.com
//production -> 生产环境 -> app.qingclass.com

//#define HTTPS_ENABLE 1

#if HTTPS_ENABLE
#   define kQCProtocol @"https"
#else
#   define kQCProtocol @"https"
#endif

#define DEV_kQCProtocol @"https"//开发和测试环境用http
//生产
#define kQCDistributionRootURI  @"streaming.qingclass.com"

#define kQCDistributionURI  [NSString stringWithFormat:@"%@://%@", kQCProtocol, kQCDistributionRootURI]
//开发
//#define kQCDevRootURI  @"api.easylesson.cn"
#define kQCDevRootURI  @"appid-ioss.xx-app.com"


#define kQCDevURI  [NSString stringWithFormat:@"%@://%@", DEV_kQCProtocol, kQCDevRootURI]
//测试
#define kQCTestRootURI  @"streaming.qcvenus.com"
#define kQCTestURI  [NSString stringWithFormat:@"%@://%@", DEV_kQCProtocol, kQCTestRootURI]


#define kQCWildddogDistributionURI  @"https://qingclass-streaming.wilddogio.com"
#define kQCWildddogDevURI  @"https://qingclass-streaming-test.wilddogio.com"

//#define kQCDistributionVersionKey   @"dbd83045-4fae-44c2-87ac-4b3eeacc853f"
//#define kQCDevVersionkey   @"d49f53c7-d204-4edd-b382-627eab7634aa"

#define kQCDistributionVersionKey   @"28aa7288-964e-42e8-a59f-7e70aa087200"
#define kQCDevVersionkey   @"28aa7288-964e-42e8-a59f-7e70aa087200"

#define kDistributionRongCloudAppKey    @"mgb7ka1nm3p0g"
#define kDevRongCloudAppKey    @"e5t4ouvperswa"



#endif /* QCAPIDefines_h */
