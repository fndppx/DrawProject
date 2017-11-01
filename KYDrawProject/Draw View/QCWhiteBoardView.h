//
//  QCWhiteBoardView.h
//  QingClass
//
//  Created by SXJH on 17/3/2.
//  Copyright © 2017年 qingclass. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "WDWhiteBoard.h"
@interface QCWhiteBoardViewModel:NSObject
@property (nonatomic,strong)NSString * roomId;
@property (nonatomic,strong)NSString * whiteBoardIndexUrl;
@end
@interface QCWhiteBoardView : UIView
@property (nonatomic,assign)BOOL isOpenDraw;
//@property (nonatomic,strong)WDWhiteBoard * whiteBoard;
@property (nonatomic,assign)float brushWidth;
@property (nonatomic,strong)UIColor * brushColor;
@property (nonatomic,assign,getter=isOpenedEarser)BOOL openedEarser;
@property (nonatomic,copy)void(^whiteBoardViewOpenResponse)(BOOL isOpened);
- (void)registerObserversWithWBModel:(QCWhiteBoardViewModel*)wbModel;
- (void)removeObservers;
@end
