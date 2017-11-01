//
//  BrushView.h
//  QingClass
//
//  Created by SXJH on 17/2/28.
//  Copyright © 2017年 qingclass. All rights reserved.
//


#import <UIKit/UIKit.h>
extern NSString *const BrushColorNotification; // 颜色
extern NSString *const BrushWidthNotification; // 大小
extern NSString *const EraserNotification; //橡皮

@interface BrushView : UIView
/** 打开画板、关闭画板回调*/
@property (nonatomic,copy)void(^openOrCloseDrawboard)(BOOL isOpened);
@property (nonatomic,assign)BOOL openedBrushBoard;
- (void)closeDrawBoard;
@end
@interface BrushViewManager : NSObject
+ (instancetype)sharedPlayer;
- (void)initConfig;
@property (nonatomic,assign)BOOL openedDrawing;
@property (nonatomic,assign)BOOL openedEraser;
@property (nonatomic,assign)float brushWidth;
@property (nonatomic,strong)UIColor * brushColor;
@end
