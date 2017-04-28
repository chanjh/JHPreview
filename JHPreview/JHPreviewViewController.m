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

#define btnHeight 57

#define previewViewFrame self.previewView.frame
#define presentViewFrame self.presentViewController.view.frame

@interface JHPreviewViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *previewView;
@property (nonatomic, strong) UIViewController *presentViewController;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *btnView;
@property (nonatomic, assign) CGFloat preferredContentHeight;
@property (nonatomic, strong) JHPeekViewController *peekViewController;
@property (nonatomic, strong) NSArray <JHPreviewAciton *> *actionsArray;

@property (nonatomic, assign) BOOL isBtnViewExist;
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
        self.isBtnViewExist = NO;
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
    [self.previewView setFrame:CGRectMake(0, 0, size.width - 20, 0)];
    [self.previewView setCenter:self.presentViewController.view.center];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:frame];
    self.scrollView = scrollView;
    // 隐藏两条滚动条
    scrollView.showsVerticalScrollIndicator = FALSE;
    scrollView.showsHorizontalScrollIndicator = FALSE;
    scrollView.delegate = self;
    
    self.scrollView.contentSize = CGSizeMake(size.width,
                                             size.height + 100);
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    
    [scrollView addSubview:self.previewView];
    [self.view addSubview:scrollView];
    
    // 动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [self.previewView setFrame:CGRectMake(0, 0, size.width - 20, _preferredContentHeight)];
    [self.previewView setCenter:self.presentViewController.view.center];
    [UIView commitAnimations];

    // 添加 arrowup 图片
    UIImageView *arrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_up"]];
    [arrowImageView setFrame:CGRectMake(self.presentViewController.view.center.x - 17,
                                        self.previewView.frame.origin.y - 20,
                                        34,
                                        11)];
    [scrollView addSubview:arrowImageView];
}

- (void)setBtnView{
    CGSize presentViewSize = presentViewFrame.size;
    CGFloat btnViewHeight = btnHeight*self.actionsArray.count;
    CGFloat leftHeight = presentViewSize.height - (previewViewFrame.origin.y - self.scrollView.contentOffset.y + previewViewFrame.size.height);
    
    UIView *btnView =[[UIView alloc]init]; ;
    self.btnView = btnView;
    if(leftHeight < btnViewHeight){
        // offset 不够时， btnView 跟在 scrollView 后面
        [self.btnView setFrame:CGRectMake(previewViewFrame.origin.x,
                                          previewViewFrame.origin.y + previewViewFrame.size.height + 20,
                                          previewViewFrame.size.width,
                                          btnViewHeight)];
        self.scrollView.contentSize = CGSizeMake(presentViewSize.width,
                                                 presentViewSize.height + btnViewHeight + 20);
        [self.scrollView addSubview:btnView];
    }else{
        // offset 足够， btnView 直接放在 self.view 底部
        [self setBtnViewInSelfView];
        
    }
    
    btnView.clipsToBounds = YES;
    [btnView.layer setCornerRadius:10];
    [btnView setBackgroundColor:[UIColor whiteColor]];
    // 遍历 action 生成对应 button
    NSInteger index = 0;
    for (JHPreviewAciton *action in self.actionsArray){
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, index*btnHeight, previewViewFrame.size.width, btnHeight)];
        [btn.layer setBorderWidth:0.5];
        [btn setTitle:action.title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:0.0f/255.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
        [btn handleControlEvent:UIControlEventAllEvents withBlock:action.handler];
        [btnView addSubview:btn];
        index++;
    }

    self.isBtnViewExist = YES;

}
- (void)showPreview{
    // 在上层 view 里加入视图
    [self.presentViewController.view addSubview:self.view];
}

# pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%f",scrollView.contentOffset.y);
    
    CGSize presentViewSize = presentViewFrame.size;
    CGFloat leftHeight =  presentViewSize.height - previewViewFrame.size.height - previewViewFrame.origin.y - 20;
    BOOL isBtnViewOnBottom = NO;
    
    if(self.btnView.frame.origin.y == presentViewFrame.size.height - btnHeight*self.actionsArray.count - 20){
        isBtnViewOnBottom = YES;
    }
    
    
    // 第一次向上 offset 到 60 时
    if(scrollView.contentOffset.y >= 60 && !self.isBtnViewExist){
        [self setBtnView];
    }
    // 当移动到 btnView 完全显示出来的时候
    else if(scrollView.contentOffset.y >= self.btnView.frame.size.height + 20 - leftHeight && self.isBtnViewExist){
        [self setBtnViewInSelfView];
    }
    // 当 btnView 已经固定在底部，并且偏移量到 btnView 上时
    CGFloat offset = previewViewFrame.origin.y + previewViewFrame.size.height - (presentViewSize.height - self.btnView.frame.size.height) + 30;
    if(scrollView.contentOffset.y <= offset
       && isBtnViewOnBottom
       && self.isBtnViewExist){
        // btnView 太低时，不进行调整
        
        
        
        [self.btnView setFrame:CGRectMake(previewViewFrame.origin.x,
                                          offset + presentViewSize.height - self.btnView.frame.size.height,
                                          previewViewFrame.size.width,
                                          self.btnView.frame.size.height)];
        
        self.scrollView.contentSize = CGSizeMake(presentViewSize.width,
                                                 offset + presentViewSize.height + 20);
        [self.btnView removeFromSuperview];
        [self.scrollView addSubview:self.btnView];
    }
    
    // 当向下移动到 半个 btn 高度时， btnView 消失
    if(self.isBtnViewExist
            &&[self.btnView.superview isEqual:self.scrollView]
            //             &&scrollView.contentOffset.y <
            ){
        
    }
    
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
}
# pragma mark - 私有方法
- (void)setBtnViewInSelfView{
    CGSize size = presentViewFrame.size;
    [self.btnView setFrame:CGRectMake(previewViewFrame.origin.x,
                                      size.height - btnHeight*self.actionsArray.count - 20,
                                      previewViewFrame.size.width,
                                      btnHeight*self.actionsArray.count)];
    [self.btnView removeFromSuperview];
    [self.view addSubview:self.btnView];
}
@end
