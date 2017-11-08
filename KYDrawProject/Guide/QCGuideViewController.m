//
//  QCGuideViewController.m
//  QingClass
//
//  Created by 0dayZh on 2017/1/6.
//  Copyright © 2017年 qingclass. All rights reserved.
//

#import "QCGuideViewController.h"
#import "GloableConstant.h"
#define kGuideVersion   @"v1"

@interface QCGuideViewController ()

@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) NSMutableArray<UIImageView *> *imageViews;
@property (nonatomic, copy) void (^handler)(void);
@property (nonatomic,strong)UIPageControl * pageControl;
@end

@implementation QCGuideViewController

+ (void)showGuideViewControllerIfNeededInWindow:(UIWindow *)window done:(void (^)(void))handler {
    if ([self shouldShowGuideViewController]) {
        QCGuideViewController *guide = QCInitialViewController(@"Guide");
        guide.handler = handler;
        window.rootViewController = guide;
    } else {
        !handler ?: handler();
    }
}

+ (BOOL)shouldShowGuideViewController {
    if ([[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"guide.%@", kGuideVersion]]) {
        return NO;
    }
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat width = CGRectGetWidth(screenBounds);
    CGFloat height = CGRectGetHeight(screenBounds);
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:screenBounds];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.contentSize = CGSizeMake(width * 3, height);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.directionalLockEnabled = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    self.scrollView = scrollView;
    
    self.imageViews = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"guide_%@_%d", kGuideVersion, i]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.frame = CGRectMake(i * width, 0, width, height);
        [scrollView addSubview:imageView];
        [self.imageViews addObject:imageView];
    }
    
    
    
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.frame = CGRectMake((_scrollView.frame.size.width-20)/2, _scrollView.frame.size.height-20-50, 20, 20);//指定位置大小
    _pageControl.numberOfPages = 3;//指定页面个数
    _pageControl.currentPage = 0;//指定pagecontroll的值，默认选中的小白点（第一个）
    //添加委托方法，当点击小白点就执行此方法
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];// 设置非选中页的圆点颜色
    
    _pageControl.currentPageIndicatorTintColor = [UIColor grayColor]; // 设置选中页的圆点颜色
    [self.view addSubview:_pageControl];
    
    
    UIImageView *lastImageView = [self.imageViews lastObject];
    lastImageView.userInteractionEnabled = YES;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(width / 4.0, height * 0.85-40, width / 2.0, 50);
    button.backgroundColor = [UIColor grayColor];
    [button setTitle:@"点击进入" forState:UIControlStateNormal];
    button.alpha = 0.5;
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [lastImageView addSubview:button];
   
}
//pagecontroll的委托方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    //    NSLog(@"%d", page);
    
    // 设置页码
    _pageControl.currentPage = page;
}

- (void)buttonPressed:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:@YES forKey:[NSString stringWithFormat:@"guide.%@", kGuideVersion]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    !self.handler ?: self.handler();
}
- (BOOL)shouldAutorotate {
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
