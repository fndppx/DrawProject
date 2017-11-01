//
//  QCWilddogSync.h
//  QingClass
//
//  Created by 0dayZh on 2016/12/6.
//  Copyright © 2016年 qingclass. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <Mantle/Mantle.h>
#import "QCWilddogSerializing.h"

@interface QCWilddogSync : NSObject

+ (void)forceSync:(id<QCWilddogSerializing>)obj forKey:(NSString *)key;
+ (void)syncIfNeeded:(id<QCWilddogSerializing>)obj forKey:(NSString *)key;

+ (void)forceSync:(id<QCWilddogSerializing>)obj forKey:(NSString *)key complete:(void (^)(BOOL success))complete;

+ (void)syncIfNeeded:(id<QCWilddogSerializing>)obj forKey:(NSString *)key complete:(void (^)(BOOL success))complete;


+ (void)syncArray:(NSArray<id<QCWilddogSerializing>> *)array forRef:(WDGSyncReference *)ref;
+ (void)syncArray:(NSArray<id<QCWilddogSerializing>> *)array forRef:(WDGSyncReference *)ref complete:(void (^)(BOOL success))complete;

+ (void)removeObjectForReference:(WDGSyncReference *)ref;
+ (void)removeObjectForReference:(WDGSyncReference *)ref complete:(void (^)(BOOL success))complete;
@end
