//
//  QCWilddogSerializing.h
//  QingClass
//
//  Created by 0dayZh on 2016/12/6.
//  Copyright © 2016年 qingclass. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WDGSyncReference;
@protocol QCWilddogSerializing <NSObject>

- (void)setNeedToSync:(BOOL)needToChange;
- (BOOL)needToSync;
- (BOOL)atom;
+ (WDGSyncReference *)syncReferenceWithKey:(NSString *)key;

@end
