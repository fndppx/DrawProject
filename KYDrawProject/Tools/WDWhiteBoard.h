//
//  WDWhiteBoard.h
//  QingClass
//
//  Created by SXJH on 17/3/13.
//  Copyright © 2017年 qingclass. All rights reserved.
//

//#import <Mantle/Mantle.h>
#import "QCWilddogSerializing.h"

@interface WDWhiteBoard : NSObject<QCWilddogSerializing>
@property (nonatomic,strong) NSMutableDictionary * point;

- (void)setNeedToSync:(BOOL)needToChange;
- (BOOL)needToSync;
- (BOOL)atom;
+ (WDGSyncReference *)syncReferenceWithKey:(NSString *)key;
+ (WDGSyncReference *)syncReferenceWithRoomId:(NSString *)roomId pptIndexUrl:(NSString*)pptIndexUrl;
@end
