
//
//  BrushView.m
//  QingClass
//
//  Created by SXJH on 17/2/28.
//  Copyright © 2017年 qingclass. All rights reserved.
//
//tag 从1000开始
#import "BrushView.h"
#import "GloableConstant.h"
NSString *const BrushColorNotification = @"BrushColorNotification";
NSString *const BrushWidthNotification = @"BrushWidthNotification";
NSString *const EraserNotification = @"EraserNotification"; //橡皮
typedef enum : NSUInteger {
    QCBrushButtonTypeSmallBrush=1000,
    QCBrushButtonTypeMiddleBrush,
    QCBrushButtonTypeBigBrush,
    QCBrushButtonTypeEraserBrush,
    QCBrushButtonTypeColorBrush,
} QCBrushButtonType;
@interface BrushView()
{
    int _count;
}
@property (weak, nonatomic) IBOutlet UIView *flowBrushView;
@property (nonatomic,strong)UIView * contentView;
@property (nonatomic,assign)BOOL detialViewIsShow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flowBrushViewOffset;
@property (weak, nonatomic) IBOutlet UIButton *smallBrush;
@property (weak, nonatomic) IBOutlet UIButton *middleBrush;
@property (weak, nonatomic) IBOutlet UIButton *bigBrush;
@property (weak, nonatomic) IBOutlet UIButton *colorBrush;
@property (nonatomic,strong)NSArray * colorArray;
@property (nonatomic,strong)NSArray * toolsArray;
@property (weak, nonatomic) IBOutlet UIButton *eraserButton;
@end
@implementation BrushView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setOpenedBrushBoard:(BOOL)openedBrushBoard{
    _openedBrushBoard = openedBrushBoard;
    _detialViewIsShow = _openedBrushBoard;
    CGFloat offset = _openedBrushBoard?0:-240;
    [UIView animateWithDuration:0.3 animations:^{
        self.flowBrushViewOffset.constant = offset;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.smallBrush.layer.cornerRadius = self.smallBrush.frame.size.height*0.5f;
    self.smallBrush.layer.masksToBounds = YES;
    self.middleBrush.layer.cornerRadius = self.middleBrush.frame.size.height*0.5f;
    self.middleBrush.layer.masksToBounds = YES;
    self.bigBrush.layer.cornerRadius = self.bigBrush.frame.size.height*0.5f;
    self.bigBrush.layer.masksToBounds = YES;
    self.colorBrush.layer.cornerRadius = self.colorBrush.frame.size.height*0.5f;
    self.colorBrush.layer.masksToBounds = YES;
    self.colorArray = @[RGB(255, 89, 89, 1),RGB(255, 231, 89, 1),RGB(89, 192, 255, 1)];
    self.toolsArray = @[self.smallBrush,self.middleBrush,self.bigBrush,self.eraserButton,self.colorBrush];
    self.colorBrush.backgroundColor = self.colorArray[0];
}

- (IBAction)onShowDetailButtonPressed:(id)sender {
    [self showBrushView:!_detialViewIsShow];
    if (self.openOrCloseDrawboard) {
        self.openOrCloseDrawboard(_detialViewIsShow);
    }
}

- (void)closeDrawBoard {
    [self showBrushView:NO];
    if (self.openOrCloseDrawboard) {
        self.openOrCloseDrawboard(_detialViewIsShow);
    }
}

- (void)showBrushView:(BOOL)show{
    _detialViewIsShow = show;
    CGFloat offset = _detialViewIsShow?0:-240;
    [UIView animateWithDuration:0.3 animations:^{
        self.flowBrushViewOffset.constant = offset;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}
- (IBAction)buttonPressed:(id)sender {
}

- (IBAction)brushButtonPressed:(id)sender {
    
    UIButton * button = sender;
    if (button.tag==QCBrushButtonTypeColorBrush){
        [BrushViewManager sharedPlayer].openedEraser = NO;;
        [[NSNotificationCenter defaultCenter]postNotificationName:EraserNotification object:nil];
    }else{
        
        
        for (int i = 0; i<self.toolsArray.count; i++) {
            UIButton * btn = [self.toolsArray objectAtIndex:i];
            if (i<3) {
                btn.layer.borderColor = [UIColor whiteColor].CGColor;
                btn.layer.borderWidth = 2;
            }
        }
    }
    
    if (button.tag<1003) {
        UIButton * btn = [self.toolsArray objectAtIndex:button.tag-1000];
        btn.layer.borderColor = RGB(89, 192, 255, 1).CGColor;
        btn.layer.borderWidth = 2;
        [BrushViewManager sharedPlayer].openedEraser = NO;;
        [[NSNotificationCenter defaultCenter]postNotificationName:EraserNotification object:nil];
        
    }
    switch (button.tag) {
        case QCBrushButtonTypeSmallBrush:
        {
            [BrushViewManager sharedPlayer].brushWidth = 2;;
            
            [[NSNotificationCenter defaultCenter]postNotificationName:BrushWidthNotification object:nil];
            
        }
            break;
        case QCBrushButtonTypeMiddleBrush:
        {
            [BrushViewManager sharedPlayer].brushWidth = 4;;
            [[NSNotificationCenter defaultCenter]postNotificationName:BrushWidthNotification object:nil];
            
        }
            break;
        case QCBrushButtonTypeBigBrush:
        {
            [BrushViewManager sharedPlayer].brushWidth = 6;;
            [[NSNotificationCenter defaultCenter]postNotificationName:BrushWidthNotification object:nil];
            
        }
            break;
        case QCBrushButtonTypeEraserBrush:
        {
            [BrushViewManager sharedPlayer].openedEraser = ![BrushViewManager sharedPlayer].openedEraser;;
            
            [[NSNotificationCenter defaultCenter]postNotificationName:EraserNotification object:nil];
            
        }
            break;
        case QCBrushButtonTypeColorBrush:
        {
            _count++;
            if (_count>2) {
                _count=0;
            }
            self.colorBrush.backgroundColor = self.colorArray[_count];
            UIColor * color = self.colorArray[_count];
            [BrushViewManager sharedPlayer].brushColor = color;;
            
            [[NSNotificationCenter defaultCenter]postNotificationName:BrushColorNotification object:nil];
            
        }
            break;
            
        default:
            break;
    }
    [self.eraserButton
     setImage:[BrushViewManager sharedPlayer].openedEraser?[UIImage imageNamed:@"eraser2_icon"]:[UIImage imageNamed:@"eraser_icon"] forState:UIControlStateNormal];

}
@end
@implementation BrushViewManager

+ (instancetype)sharedPlayer {
    static BrushViewManager *brush;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        brush = [[self alloc] init];
    });
    
    return brush;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    
    return self;
}
- (void)initConfig {
    [BrushViewManager sharedPlayer].openedEraser = NO;
    [BrushViewManager sharedPlayer].brushWidth = 2;
    [BrushViewManager sharedPlayer].brushColor = RGB(255, 89, 89, 1);
}
@end
