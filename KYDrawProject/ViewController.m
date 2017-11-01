//
//  ViewController.m
//  KYDrawProject
//
//  Created by 魏柯岩 on 2017/11/2.
//  Copyright © 2017年 mengmengda. All rights reserved.
//
#import "QCWhiteBoardView.h"
#import "ViewController.h"
#import "BrushView.h"
#import "Masonry.h"
#import "UIImageView+AFNetworking.h"
#import "RootViewController.h"
@interface ViewController ()
@property (nonatomic, strong)QCWhiteBoardView * whiteBoardView;
@property (nonatomic,strong) BrushView * brushView;

@end

@implementation ViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(switchColorNotification:) name:BrushColorNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(switchBrushWidthNotification:) name:BrushWidthNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(switchEraserNotification:) name:EraserNotification object:nil];
    UIImageView * image = [[UIImageView alloc]init];
    [self.view addSubview:image];
    image.contentMode = UIViewContentModeScaleAspectFill;
    [image setImageWithURL:[NSURL URLWithString:@"http://imgsrc.baidu.com/imgad/pic/item/78310a55b319ebc4b37daea08926cffc1e171685.jpg"] placeholderImage:nil];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
    
    
    
    [self setWhiteBoard];
    
    [self initBrushView];

    
}
- (void)switchColorNotification:(NSNotification*)notification{
    UIColor * color = [BrushViewManager sharedPlayer].brushColor;
    if (_whiteBoardView) {
        [_whiteBoardView setBrushColor:color];
    }
}
- (void)switchBrushWidthNotification:(NSNotification*)notification{
    float width = [BrushViewManager sharedPlayer].brushWidth;
    if (_whiteBoardView) {
        [_whiteBoardView setBrushWidth:width];
    }
}
- (void)switchEraserNotification:(NSNotification*)notification{
    BOOL isOpened = [BrushViewManager sharedPlayer].openedEraser;
    if (_whiteBoardView) {
        [_whiteBoardView setOpenedEarser:isOpened];
    }
}
- (void)initBrushView
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BrushView" owner:self options:nil];
    _brushView = nib[0];
    _brushView.frame = CGRectMake(15,15, CGRectGetWidth(_brushView.frame), CGRectGetHeight(_brushView.frame));
    _brushView.userInteractionEnabled = YES;
    _brushView.hidden = NO;
    _brushView.layer.cornerRadius = _brushView.frame.size.height*0.5;
    _brushView.layer.masksToBounds = YES;
    [self.view addSubview:_brushView];
    __weak typeof(self)weakSelf = self;
    [[BrushViewManager sharedPlayer] setOpenedDrawing:YES];

    _brushView.openOrCloseDrawboard = ^(BOOL isOpened){
//        weakSelf.collectionView.scrollEnabled = !isOpened;
        [[BrushViewManager sharedPlayer] setOpenedDrawing:YES];
        if (isOpened) {
//            weakSelf.downView.alpha = 0;
//            [weakSelf addHalfButtonToView:weakSelf];
        }else {
//            [weakSelf addHalfButtonToView:weakSelf.downView];
        }
//        !weakSelf.openedBrushBoardResponse?:weakSelf.openedBrushBoardResponse(isOpened);
    };

    [[BrushViewManager sharedPlayer] initConfig];
    
    [_brushView setOpenedBrushBoard:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)setWhiteBoard{
    if (!_whiteBoardView) {
        _whiteBoardView = [[QCWhiteBoardView alloc]init];
        [self.view addSubview:_whiteBoardView];
        _whiteBoardView.isOpenDraw = YES;
        _whiteBoardView.backgroundColor = [UIColor whiteColor];
        _whiteBoardView.alpha = 0.5;
    }
    [self setBrushViewConfig];
//    self.whiteBoardView.frame = self.view.bounds;
    [_whiteBoardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(@0);
    }];
    [self loadLineData];

}
- (void)viewLayoutMarginsDidChange{
    [super viewLayoutMarginsDidChange];
    [self loadLineData];

    
}
- (void)loadLineData{
    QCWhiteBoardViewModel * model = [QCWhiteBoardViewModel new];
//    NSArray * array =  [self.imageUrl componentsSeparatedByString:@"/"];
//    NSString * onlyValue =  [array lastObject];
//    onlyValue = [onlyValue stringByReplacingOccurrencesOfString:@".jpg" withString:@""];
    model.roomId =@"111";
    model.whiteBoardIndexUrl = @"keyan1111";
    [_whiteBoardView removeObservers];
    [_whiteBoardView registerObserversWithWBModel:model];
//    [self.headImageView markWithLogo:@"pptlogo" position:UIImageViewWaterMarkPositionRightTop];
}

- (void)setBrushViewConfig{
    BOOL isOpened = [BrushViewManager sharedPlayer].openedEraser;
    
    if (_whiteBoardView) {
        [_whiteBoardView setOpenedEarser:isOpened];
    }
    float width = [BrushViewManager sharedPlayer].brushWidth;
    
    if (_whiteBoardView) {
        [_whiteBoardView setBrushWidth:width];
    }
    UIColor * color = [BrushViewManager sharedPlayer].brushColor;
    if (_whiteBoardView) {
        [_whiteBoardView setBrushColor:color];
    }
}

@end
