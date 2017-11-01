//
//  QCWilddogSync.m
//  QingClass
//
//  Created by 0dayZh on 2016/12/6.
//  Copyright © 2016年 qingclass. All rights reserved.
//

#import "QCWilddogSync.h"
#import <Wilddog/Wilddog.h>
#import "MJExtension.h"
@implementation QCWilddogSync

+ (void)forceSync:(id<QCWilddogSerializing>)obj forKey:(NSString *)key {
    [self forceSync:obj forKey:key complete:nil];
}

+ (void)syncIfNeeded:(id<QCWilddogSerializing>)obj forKey:(NSString *)key {
    [self syncIfNeeded:obj forKey:key complete:nil];
}

+ (NSMutableDictionary *)mutableJSONFromJSON:(NSDictionary *)json {
    NSMutableDictionary *mutableJson = [NSMutableDictionary dictionaryWithCapacity:json.count];
    [json enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)obj;
            if (dict.count) {
                [mutableJson setObject:obj forKey:key];
            }
        } else if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *array = (NSArray *)obj;
            if (array.count) {
                [mutableJson setObject:obj forKey:key];
            }
        } else if ((NSNull *)obj != [NSNull null]) {
            [mutableJson setObject:obj forKey:key];
        }
    }];
    if (mutableJson.count > 0 && !mutableJson[@"timestamp"]) {
        [mutableJson setObject:[WDGServerValue timestamp] forKey:@"timestamp"];
    }
    
    return mutableJson;
}

+ (void)forceSync:(id<QCWilddogSerializing>)obj forKey:(NSString *)key complete:(void (^)(BOOL success))complete {
    WDGSyncReference *reference = [[obj class] syncReferenceWithKey:key];
    if (![obj isKindOfClass:[NSObject class]]) {
        return;
    }
    NSDictionary *json = ((NSObject*)obj).mj_keyValues;

    NSMutableDictionary *mutableJson = [self mutableJSONFromJSON:json];

    if ([obj atom]) {
        QCLog(@"[野狗] atom: ture");
        [reference runTransactionBlock:^WDGTransactionResult * _Nonnull(WDGMutableData * _Nonnull currentData) {
            NSMutableDictionary *post = currentData.value;
            
            if ([post isEqualToDictionary:mutableJson]) {
                QCLog(@"[野狗] aboort, reason: not modify");
                return [WDGTransactionResult abort];
            }
            
            if (post.count == mutableJson.count) {
                NSMutableArray *modifiyKeys = [NSMutableArray new];
                [mutableJson enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    if (![post[key] isEqual:obj]) {
                        [modifiyKeys addObject:key];
                    }
                }];
                
                if (1 == modifiyKeys.count && [[modifiyKeys firstObject] isEqualToString:@"timestamp"]) {
                    QCLog(@"[野狗] aboort, reason: not modify expect timestamp");
                    return [WDGTransactionResult abort];
                } else {
                    QCLog(@"[野狗] success");
                    currentData.value = mutableJson;
                    return [WDGTransactionResult successWithValue:currentData];
                }
            } else {
                QCLog(@"[野狗] success");
                currentData.value = mutableJson;
                return [WDGTransactionResult successWithValue:currentData];
            }
        } andCompletionBlock:^(NSError * _Nullable error, BOOL committed, WDGDataSnapshot * _Nullable snapshot) {
            if (error) {
                QCLog(@"[野狗] error: %@", error);
            } else {
                QCLog(@"[野狗] success");
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                !complete ?: complete(nil == error);
            });
        } withLocalEvents:NO];
    } else {
        QCLog(@"[野狗] atom: false");
        [reference setValue:mutableJson withCompletionBlock:^(NSError * _Nullable error, WDGSyncReference * _Nonnull ref) {
            if (error) {
                QCLog(@"[野狗] error: %@", error);
            } else {
                QCLog(@"[野狗] success");
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                !complete ?: complete(nil == error);
            });
        }];
    }
    
    [obj setNeedToSync:NO];
}

+ (void)syncIfNeeded:(id<QCWilddogSerializing>)obj forKey:(NSString *)key complete:(void (^)(BOOL success))complete {
    if ([obj needToSync]) {
        [self forceSync:obj forKey:key complete:complete];
    }
}

+ (void)syncArray:(NSArray<id<QCWilddogSerializing>> *)array forRef:(WDGSyncReference *)ref {
    return [self syncArray:array forRef:ref complete:nil];
}

+ (void)syncArray:(NSArray<id<QCWilddogSerializing>> *)array forRef:(WDGSyncReference *)ref complete:(void (^)(BOOL success))complete {
    if (!array || 0 == array.count) {
        [self removeObjectForReference:ref];
    } else {
        NSMutableArray<NSDictionary *> *jsonArray = [NSMutableArray arrayWithCapacity:array.count];
        for (id<QCWilddogSerializing> obj in array) {
            if (![obj isKindOfClass:[NSObject class]]) {
                return;
            }
            NSDictionary *json = ((NSObject*)obj).mj_keyValues;
            NSMutableDictionary *mutableJson = [self mutableJSONFromJSON:json];
            [jsonArray addObject:mutableJson];
        }
        [ref setValue:jsonArray withCompletionBlock:^(NSError * _Nullable error, WDGSyncReference * _Nonnull ref) {
            if (error) {
                QCLog(@"%@", error);
            }
            !complete ?: complete(nil == error);
        }];
    }
}



+ (void)removeObjectForReference:(WDGSyncReference *)ref {
    [self removeObjectForReference:ref complete:nil];
}

+ (void)removeObjectForReference:(WDGSyncReference *)ref complete:(void (^)(BOOL success))complete {
    [ref removeValueWithCompletionBlock:^(NSError * _Nullable error, WDGSyncReference * _Nonnull ref) {
        !complete ?: complete(nil == error);
    }];
}

@end
