//
//  QCLog.h
//  QingClass
//
//  Created by 0dayZh on 2016/11/16.
//  Copyright © 2016年 qingclass. All rights reserved.
//

#ifndef QCLog_h
#define QCLog_h

#ifdef DEBUG
#   define QCLog(...) NSLog(__VA_ARGS__)
#   define QCLogMethod() QCLog(@"[%@(%p) %@] invoked", NSStringFromClass([self class]), self, NSStringFromSelector(_cmd))
#else
#   define QCLog(...) (void)0
#   define QCLogMethod()    (void)0
#endif  // #ifdef DEBUG

#endif /* QCLog_h */
