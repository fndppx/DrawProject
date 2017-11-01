//
//  QCDrawView.m
//  QingClass
//
//  Created by SXJH on 17/3/2.
//  Copyright © 2017年 qingclass. All rights reserved.
//

#import "QCDrawView.h"
#import "QCPath.h"
#import "QCWhiteBoardView.h"
#import "BrushView.h"
@interface QCDrawView()
@property (nonatomic, assign) CGFloat drawViewHeight;
@property (nonatomic, assign) CGFloat mydrawViewHeight;
@property (nonatomic, strong) NSMutableArray *paths;
@property (nonatomic, strong) QCPath *currentPath;
@property (nonatomic, strong) UITouch *currentTouch;
@property (nonatomic, assign) CGContextRef context;
@end
@implementation QCDrawView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.paths = [NSMutableArray array];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self!=nil) {
        self.paths = [NSMutableArray array];
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (void)addPath:(QCPath *)path withDrawViewHeight:(CGFloat)height
{
    [self.paths addObject:path];
    self.drawViewHeight = height;
    [self setNeedsDisplay];
}

- (void)drawPath:(QCPath *)path withContext:(CGContextRef)context isMyDraw:(BOOL)isMyDraw
{
    if (path.points.count > 1) {
        QCPoint *point = path.points[0];

        float  scale = self.frame.size.height/point.drawHeight;
        if (point.drawHeight<=0) {
            scale = 1;
        }
//        QCLog(@"%f===%f==",path.width,path.width*scale);
        CGContextSetLineWidth(context,path.width==0?1:path.width*scale);
        CGContextBeginPath(context);
        CGContextSetStrokeColorWithColor(context, path.color.CGColor);
       
        CGContextMoveToPoint(context, point.x*scale, point.y*scale);
        for (NSUInteger i = 0; i < path.points.count; i++) {
            QCPoint *point = path.points[i];
            CGContextAddLineToPoint(context, point.x*scale, point.y*scale);
        }
        CGContextDrawPath(context, kCGPathStroke);
    }
}

- (void)removePoints{
    [self.paths removeAllObjects];
    if (self.currentPath) {
        CGContextClearRect(self.context, self.bounds);
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.context==nil) {
        self.context = UIGraphicsGetCurrentContext();
    }
    for (QCPath *path in self.paths) {
        [self drawPath:path withContext:self.context isMyDraw:NO];
    }
    if (self.currentPath != nil) {
        [self drawPath:self.currentPath withContext:self.context isMyDraw:YES];
    }
}

- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    if (self.currentPath == nil &&!_openedEraser && [BrushViewManager sharedPlayer].openedDrawing) {
        self.currentTouch = [touches anyObject];
        self.currentPath = [[QCPath alloc] initWithColor:self.drawColor];
        self.currentPath.width = self.lineWidth;
        CGPoint touchPoint = [self.currentTouch locationInView:self];
        [self.currentPath addPoint:touchPoint drawHeight:self.frame.size.height];
        [self setNeedsDisplay];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.currentPath != nil&&!_openedEraser && [BrushViewManager sharedPlayer].openedDrawing) {
        for (UITouch *touch in touches) {
            if (self.currentTouch == touch) {
                CGPoint touchPoint = [self.currentTouch locationInView:self];
                [self.currentPath addPoint:touchPoint drawHeight:self.frame.size.height];
                [self setNeedsDisplay];
            }
        }
        
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.currentPath != nil) {
        for (UITouch *touch in touches) {
            if (self.currentTouch == touch) {
                self.currentPath = nil;
                self.currentTouch = nil;
                [self setNeedsDisplay];
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([BrushViewManager sharedPlayer].openedDrawing) {
        if (_openedEraser) {
            if ([self.delegate respondsToSelector:@selector(drawView:didFinishDrawingPath:)]) {
                [self.delegate drawView:self didFinishDrawingPath:self.currentPath];
            }
        }else{
            if (self.currentPath != nil) {
                for (UITouch *touch in touches) {
                    if (self.currentTouch == touch) {
                        [self.paths addObject:self.currentPath];
                        if ([self.delegate respondsToSelector:@selector(drawView:didFinishDrawingPath:)]) {
                            [self.delegate drawView:self didFinishDrawingPath:self.currentPath];
                        }
                        self.currentPath = nil;
                        self.currentTouch = nil;
                    }
                }
            }
        }
    }
}


@end
