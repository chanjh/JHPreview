//
//  JHPreviewViewController.m
//  previewTest
//
//  Created by 陈嘉豪 on 2017/4/26.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import "JHPreviewViewController.h"
#import "JHPeekViewController.h"
#import "UIButton+Block.h"

@interface JHPreviewViewController ()

@property (nonatomic, strong) UIView *previewView;
@property (nonatomic, strong) UIViewController *presentViewController;
@property (nonatomic, assign) CGFloat preferredContentHeight;
@property (nonatomic, strong) JHPeekViewController *peekViewController;
@property (nonatomic, strong) NSArray <JHPreviewAciton *> *actionsArray;

@property (nonatomic, strong) UIVisualEffectView *visualEffectView;

@end

@implementation JHPreviewViewController


- (instancetype)initWithPresentViewController:(UIViewController *)presentViewController
                              acitonsArray:(NSArray <JHPreviewAciton *>*)actionsArray
                               previewView:(__kindof UIView *)previewView
                 andPreferredContentHeight:(CGFloat)height{
    if(self = [super init]){
        self.previewView = previewView;
        self.presentViewController = presentViewController;
        self.preferredContentHeight = height;
        self.actionsArray = actionsArray;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    // 设置 view 的大小， 覆盖背后的视图
    CGRect frame = self.presentViewController.view.frame;
    CGPoint point = frame.origin;
    CGSize size = frame.size;
    [self.view setFrame:CGRectMake(point.x, point.y, size.width, size.height)];
    
    // 添加毛玻璃效果视图
    UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.visualEffectView = [[UIVisualEffectView alloc]initWithEffect:effect];
    [self.visualEffectView setFrame:self.view.frame];
    [self.view addSubview:self.visualEffectView];

    // 添加 Preview 视图
    // 设置圆角矩形
    self.previewView.clipsToBounds =YES;
    [self.previewView.layer setCornerRadius:10];
    [self.previewView setFrame:CGRectMake(0, 0, self.presentViewController.view.frame.size.width - 20, _preferredContentHeight)];
    [self.previewView setCenter:self.presentViewController.view.center];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:frame];
    // 隐藏两条滚动条
    scrollView.showsVerticalScrollIndicator = FALSE;
    scrollView.showsHorizontalScrollIndicator = FALSE;
    scrollView.bounces = NO;
    
    // 添加图片
    
    // 添加按钮
    CGFloat btnHeight = 57;
    UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(self.previewView.frame.origin.x, size.height, self.previewView.frame.size.width, btnHeight*self.actionsArray.count)];
    [btnView.layer setCornerRadius:10];
    btnView.clipsToBounds = YES;
    [btnView setBackgroundColor:[UIColor whiteColor]];

    NSInteger index = 0;
    for (JHPreviewAciton *action in self.actionsArray){
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, index*btnHeight, self.previewView.frame.size.width, btnHeight)];
        [btn.layer setBorderWidth:0.5];
        [btn setTitle:action.title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:0.0f/255.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
        [btn handleControlEvent:UIControlEventAllEvents withBlock:action.handler];
        [btnView addSubview:btn];
        index++;
    }
    
    scrollView.contentSize = CGSizeMake(size.width, size.height + btnView.frame.size.height);
    [scrollView setContentOffset:CGPointMake(0, 0)];
    
    // TODO 提交动画
    [scrollView addSubview:btnView];
    [scrollView addSubview:self.previewView];
    [self.view addSubview:scrollView];
}

- (void)showPreview{
    // 在上层 view 里加入视图
    [self.presentViewController.view addSubview:self.view];
}


@end
