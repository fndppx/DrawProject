//
//  QCPath.h
//  QingClass
//
//  Created by SXJH on 17/3/2.
//  Copyright © 2017年 qingclass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface QCPoint : NSObject

@property (nonatomic, readonly) CGFloat x;
@property (nonatomic, readonly) CGFloat y;
@property (nonatomic, readonly) CGFloat drawHeight;

- (id)initWithCGPoint:(CGPoint)point drawHeight:(CGFloat)drawHeight;
@end
@interface QCPath :NSObject
@property (nonatomic, strong, readonly) NSMutableArray *points;
@property (nonatomic, strong, readonly) UIColor *color;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign,readonly) CGFloat drawHeight;
@property (nonatomic,assign) long long lastUpdate;

- (id)initWithColor:(UIColor *)color;
- (id)initWithPoints:(NSMutableArray *)points color:(UIColor *)color width:(CGFloat)width drawHeight:(CGFloat)height;
+ (QCPath *)parse:(NSDictionary *)dictionary;
+ (CGFloat)parseLineWidth:(NSNumber *)number;
+ (CGFloat)parseDrawViewHeight:(NSNumber *)number;
- (NSDictionary *)serializeWithHeight:(CGFloat)height;
- (void)addPoint:(CGPoint)point drawHeight:(CGFloat)drawHeight;
@end
