//
//  GloableConstant.h
//  XCTabViewController
//
//  Created by xiangchao on 2017/2/23.
//  Copyright © 2017年 qingclass. All rights reserved.
//

#ifndef GloableConstant_h
#define GloableConstant_h

#define DesignableProperties \
@property (nonatomic, strong) IBInspectable UIColor *borderColor;\
@property (nonatomic) IBInspectable CGFloat borderWidth;\
@property (nonatomic) IBInspectable CGFloat cornerRadius;

#define DesignableSetters \
- (void)setBorderColor:(UIColor *)borderColor\
{\
_borderColor = borderColor;\
self.layer.borderColor = _borderColor.CGColor;\
}\
\
- (void)setBorderWidth:(CGFloat)borderWidth\
{\
_borderWidth = borderWidth;\
self.layer.borderWidth = _borderWidth;\
}\
\
- (void)setCornerRadius:(CGFloat)cornerRadius\
{\
_cornerRadius = cornerRadius;\
self.layer.cornerRadius = _cornerRadius;\
self.clipsToBounds = YES;\
}\

#define RGB(r,g,b,a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b/ 255.0 alpha:a]

#define weakObject(object) __weak typeof(object) weakObject = object
#define strongObject(object) __strong typeof(object) strongObject = object
#define weakSelf() __weak typeof(self) weakSelf = self
#define strongSelf() __strong typeof(weakSelf) strongSelf = weakSelf

#endif /* GloableConstant_h */
