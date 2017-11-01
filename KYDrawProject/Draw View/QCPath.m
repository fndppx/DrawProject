
//
//  QCPath.m
//  QingClass
//
//  Created by SXJH on 17/3/2.
//  Copyright © 2017年 qingclass. All rights reserved.
//

#import "QCPath.h"
@interface QCPoint ()
@property (nonatomic, readwrite) CGFloat x;
@property (nonatomic, readwrite) CGFloat y;
@property (nonatomic, readwrite) CGFloat drawHeight;

@end

@implementation QCPoint

- (id)initWithCGPoint:(CGPoint)point drawHeight:(CGFloat)drawHeight
{
    self = [super init];
    if (self != nil) {
        self->_x = point.x;
        self->_y = point.y;
        self->_drawHeight = drawHeight;
    }
    return self;
}

+ (QCPoint *)parse:(id)obj
{
    // parse a point from a JSON representation
    if (![obj isKindOfClass:[NSDictionary class]]) {
        // wrong type, parsing failed
        return nil;
    }
    
    NSDictionary *dictionary = (NSDictionary *)obj;
    if (![dictionary[@"x"] isKindOfClass:[NSNumber class]]) {
        // no required value "x" found or wrong type, parsing failed
        return nil;
    }
    if (![dictionary[@"y"] isKindOfClass:[NSNumber class]]) {
        // no required value "y" found or wrong type, parsing failed
        return nil;
    }
    
    // parse point into CGPoint and convert to FDPoint
    CGPoint point = CGPointMake([dictionary[@"x"] floatValue], [dictionary[@"y"] floatValue]);
    return [[QCPoint alloc] initWithCGPoint:point drawHeight:[dictionary[@"drawViewHeight"] floatValue]];
}

@end
@interface QCPath()
@property (nonatomic, strong, readwrite) NSMutableArray *points;
@property (nonatomic, strong, readwrite) UIColor *color;
@end
@implementation QCPath

- (id)initWithColor:(UIColor *)color
{
    self = [super init];
    if (self != nil) {
        self->_points = [NSMutableArray array];
        self->_color = color;
    }
    return self;
}

- (id)initWithPoints:(NSMutableArray *)points color:(UIColor *)color width:(CGFloat)width drawHeight:(CGFloat)height
{
    self = [super init];
    if (self != nil) {
        self->_points = [points mutableCopy];
        self->_color = color;
        self->_width = width;
        self->_drawHeight = height;
    }
    return self;
}

- (void)addPoint:(CGPoint)point drawHeight:(CGFloat)drawHeight
{
    [self.points addObject:[[QCPoint alloc] initWithCGPoint:point drawHeight:drawHeight]];
}

+ (QCPath *)parse:(NSDictionary *)dictionary
{
    
    if (![dictionary[@"color"] isKindOfClass:[NSNumber class]]) {
        return nil;
    }
    
    if (![dictionary[@"lineWidth"] isKindOfClass:[NSNumber class]]) {
        return nil;
    }
    if (![dictionary[@"points"] isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    UIColor *color = [QCPath parseColor:dictionary[@"color"]];
    
    CGFloat width = [QCPath parseLineWidth:dictionary[@"lineWidth"]];
    
    NSArray *rawPoints = dictionary[@"points"];
    NSMutableArray *points = [NSMutableArray array];
    for (id obj in rawPoints) {
        QCPoint *point = [QCPoint parse:obj];
        if (point != nil) {
            [points addObject:point];
        } else {
            NSLog(@"Not a valid point: %@", obj);
        }
    }
    return [[QCPath alloc] initWithPoints:points color:color width:width drawHeight:1];
}

- (NSDictionary *)serializeWithHeight:(CGFloat)height
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    dictionary[@"color"] = [QCPath serializeColor:self.color];
    dictionary[@"lineWidth"] = [NSNumber numberWithFloat:self.width];;
    NSMutableArray *points = [NSMutableArray array];
    for (QCPoint *point in self.points) {
        [points addObject:@{ @"x": [NSNumber numberWithInteger:point.x], @"y": [NSNumber numberWithInteger:point.y],@"drawViewHeight":[NSNumber numberWithInteger:height]}];
    }
    dictionary[@"points"] = points;
    return dictionary;
}

+ (UIColor *)parseColor:(NSNumber *)number
{
    NSInteger integer = [number integerValue];
    CGFloat alpha = ((integer >> 24) & 0xff)/255.0;
    CGFloat red = ((integer >> 16) & 0xff)/255.0;
    CGFloat green = ((integer >> 8) & 0xff)/255.0;
    CGFloat blue = (integer & 0xff)/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (CGFloat)parseLineWidth:(NSNumber *)number
{
    NSInteger integer = [number integerValue];
    
    return integer;
}

+ (CGFloat)parseDrawViewHeight:(NSNumber *)number
{
    NSInteger integer = [number integerValue];
    
    return integer;
}
+ (NSNumber *)serializeColor:(UIColor *)color
{
    uint32_t integer = 0;
    CGFloat red, green, blue, alpha;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    integer += ((int)(alpha * 255) & 0xff) << 24;
    integer += ((int)(red * 255) & 0xff) << 16;
    integer += ((int)(green * 255) & 0xff) << 8;
    integer += ((int)(blue * 255) & 0xff);
    return [NSNumber numberWithInteger:integer];
}
@end
