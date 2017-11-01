



//
//  QCWhiteBoardView.m
//  QingClass
//
//  Created by SXJH on 17/3/2.
//  Copyright © 2017年 qingclass. All rights reserved.
//

#import "QCWhiteBoardView.h"
#import "BrushView.h"
#import "QCDrawView.h"
#import "Masonry.h"
#import <WilddogSync/WilddogSync.h>
#import "QCWilddogSync.h"
#import "WDWhiteBoard.h"
NSString * BrushBoardKeys = @"brushboardkeys";
@interface QCWhiteBoardView()<QCDrawViewDelegate>
@property (nonatomic,strong) QCDrawView * drawView;
@property (nonatomic,strong) WDGSyncReference * whiteBoardReference;
@property (nonatomic,assign) WDGSyncHandle whiteBoardHandle;
@property (nonatomic,strong) QCWhiteBoardViewModel * currentWhiteBoardViewModel;
@property (nonatomic,strong) NSMutableSet *outstandingPaths;
@end
@implementation QCWhiteBoardView
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _brushWidth = 2;
        _outstandingPaths = [NSMutableSet set];
        _drawView = [[QCDrawView alloc]init];
        _drawView.userInteractionEnabled = YES;
        _drawView.lineWidth = 2;
        _drawView.drawColor = [UIColor redColor
                               ];
        [self addSubview:_drawView];
        
        [_drawView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
    }
    return self;
}
#pragma mark - SETTER
- (void)setBrushWidth:(float)brushWidth{
    _brushWidth = brushWidth;
    if (_drawView) {
        _drawView.lineWidth = _brushWidth;
    }
}

- (void)setBrushColor:(UIColor *)brushColor{
    _brushColor = brushColor;
    if (_drawView) {
        _drawView.drawColor = _brushColor;
    }
}
- (void)setOpenedEarser:(BOOL)openedEarser{
    _openedEarser = openedEarser;
    if (_drawView) {
        _drawView.openedEraser = _openedEarser;
    }
}
- (void)setIsOpenDraw:(BOOL)isOpenDraw
{
    [self willChangeValueForKey:@"isOpenDraw"];
    _isOpenDraw = isOpenDraw;
    _drawView.userInteractionEnabled = _isOpenDraw;
    [self didChangeValueForKey:@"isOpenDraw"];
}
#pragma mark - registerObserver
- (void)registerObserversWithWBModel:(QCWhiteBoardViewModel*)wbModel{
    self.currentWhiteBoardViewModel = wbModel;
    _drawView.delegate = self;
    __weak typeof(self)weakSelf = self;
    //TODO:调试专用
//    WDGSyncReference *reference = [[WDGSync sync] referenceWithPath:[NSString stringWithFormat:@"/v1/whiteboard"]];
//    [reference removeValue];
    [self.outstandingPaths removeAllObjects];
    [self.drawView removePoints];
    WDGSyncReference  * ref = [WDWhiteBoard syncReferenceWithRoomId:wbModel.roomId pptIndexUrl:wbModel.whiteBoardIndexUrl];
    WDGSyncHandle handle = [[[ref queryLimitedToFirst:1000] queryOrderedByKey]
                            observeEventType:WDGDataEventTypeValue
                            withBlock:^(WDGDataSnapshot * _Nonnull snapshot) {
                                if (snapshot.value) {
                                    WDGDataSnapshot *child = nil;
                                    WDGDataSnapshot *grandchild = nil;
                                    NSEnumerator *enumerator = snapshot.children;
                                    while (child = [enumerator nextObject]) {
                                        NSEnumerator *enumerator = child.children;
                                        while (grandchild = [enumerator nextObject]) {
                                            if (![weakSelf.outstandingPaths containsObject:grandchild.key]) {
                                                QCPath *path = [QCPath parse:grandchild.value];
                                                if (path != nil) {
                                                    if (weakSelf.drawView != nil) {
                                                        [weakSelf.drawView addPath:path withDrawViewHeight:path.drawHeight];
                                                    }
                                                }
                                                [weakSelf.outstandingPaths addObject:grandchild.key];
                                            }
                                        }
                                    }
                                }else{
                                    [weakSelf.outstandingPaths removeAllObjects];
                                    [weakSelf.drawView removePoints];
                                }
                                
                            }];
    self.whiteBoardReference = ref;
    self.whiteBoardHandle = handle;
}
#pragma mark - removeObserver
- (void)removeObservers{
    if (self.whiteBoardReference) {
        [self.whiteBoardReference removeObserverWithHandle:self.whiteBoardHandle];
        self.whiteBoardReference = nil;
    }
}
- (void)dealloc{
    [self removeObservers];
}
#pragma mark - QCDrawViewDelegate
- (void)drawView:(QCDrawView *)view didFinishDrawingPath:(QCPath *)path{
    if (self.isOpenedEarser) {
        WDGSyncReference  * ref = [WDWhiteBoard syncReferenceWithRoomId:self.currentWhiteBoardViewModel.roomId pptIndexUrl:self.currentWhiteBoardViewModel.whiteBoardIndexUrl];
        [ref removeValue];
        [self.outstandingPaths removeAllObjects];

    }else{
        if (![BrushViewManager sharedPlayer].openedDrawing) {
            return;
        }
        WDGSyncReference *pathRef = [[self.whiteBoardReference child:BrushBoardKeys] childByAutoId];
        NSString * name = pathRef.key;
        [self.outstandingPaths addObject:name];
        __weak typeof(self)weakSelf = self;
        [pathRef setValue:[path serializeWithHeight:self.frame.size.height] withCompletionBlock:^(NSError *error, WDGSyncReference *ref) {
            [weakSelf.outstandingPaths removeObject:name];
        }];
    }
}

@end
@implementation QCWhiteBoardViewModel
@end
