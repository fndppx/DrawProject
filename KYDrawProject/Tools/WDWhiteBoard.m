//
//  WDWhiteBoard.m
//  QingClass
//
//  Created by SXJH on 17/3/13.
//  Copyright © 2017年 qingclass. All rights reserved.
//

#import "WDWhiteBoard.h"
#import <Wilddog/Wilddog.h>
@implementation WDWhiteBoard{
    BOOL _hasChanged;
}

- (id)init
{
    if (self = [super init]) {
        _point = [NSMutableDictionary new];
    }
    return self;
}


#pragma mark - QCWilddogSerializing

- (void)setNeedToSync:(BOOL)needToChange {
    _hasChanged = needToChange;
}

- (BOOL)needToSync {
    return _hasChanged;
}

- (BOOL)atom {
    return NO;
}
+ (WDGSyncReference *)syncReferenceWithRoomId:(NSString *)roomId pptIndexUrl:(NSString*)pptIndexUrl {
    WDGSyncReference *reference = [[WDGSync sync] referenceWithPath:[NSString stringWithFormat:@"/v1/whiteboard/%@/%@",roomId, pptIndexUrl]];
    return reference;
}
+ (WDGSyncReference *)syncReferenceWithKey:(NSString *)key {
    WDGSyncReference *reference = [[WDGSync sync] referenceWithPath:[NSString stringWithFormat:@"/v1/whiteboard/%@", key]];
    return reference;
}
@end
