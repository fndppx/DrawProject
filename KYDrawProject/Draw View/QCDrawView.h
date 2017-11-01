//
//  QCDrawView.h
//  QingClass
//
//  Created by SXJH on 17/3/2.
//  Copyright © 2017年 qingclass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCPath.h"
@class QCDrawView;
@protocol QCDrawViewDelegate <NSObject>

- (void)drawView:(QCDrawView *)view didFinishDrawingPath:(QCPath *)path;

@end
@interface QCDrawView : UIView
@property (nonatomic, strong) UIColor *drawColor;
@property (nonatomic,assign) float lineWidth;
@property (nonatomic,assign) BOOL openedEraser;
@property (nonatomic, weak) id<QCDrawViewDelegate> delegate;
- (void)addPath:(QCPath *)path withDrawViewHeight:(CGFloat)height;
- (void)removePoints;
@end
