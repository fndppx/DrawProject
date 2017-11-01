//
//  QCWebViewController.m
//  QingClass
//
//  Created by 0dayZh on 2016/11/23.
//  Copyright © 2016年 qingclass. All rights reserved.
//

#import "QCWebViewController.h"

@interface QCWebViewController ()

@end

@implementation QCWebViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:webView];
    self.webView = webView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.webView.frame = self.view.bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

@end
