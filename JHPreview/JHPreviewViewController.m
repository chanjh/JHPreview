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

@interface JHPreviewViewController ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *previewView;
@property (nonatomic, strong) UIViewController *presentViewController;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *btnView;
@property (nonatomic, assign) CGFloat preferredContentHeight;
@property (nonatomic, strong) JHPeekViewController *peekViewController;
@property (nonatomic, strong) NSArray <JHPreviewAciton *> *actionsArray;
@property (nonatomic, assign) CGFloat startOffset;

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
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupUI];
    
}
- (void)setupUI{
    // 设置 view 的大小， 覆盖背后的视图
    CGPoint point = presentViewFrame.origin;
    CGSize size = presentViewFrame.size;
    [self.view setFrame:CGRectMake(point.x, point.y, size.width, size.height)];
    
    // 添加毛玻璃效果视图
    UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.visualEffectView = [[UIVisualEffectView alloc]initWithEffect:effect];
    [self.visualEffectView setFrame:presentViewFrame];
    [self.view addSubview:self.visualEffectView];
    
    [self.view addSubview:self.scrollView];
    
    // 添加 Preview 视图
    // 设置圆角矩形
    self.previewView.clipsToBounds =YES;
    [self.previewView.layer setCornerRadius:10];
    [self.previewView setFrame:CGRectMake(0, 0, size.width - 20, 0)];
    [self.previewView setCenter:self.presentViewController.view.center];
    
    // 动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [self.previewView setFrame:CGRectMake(0, 0, size.width - 20, _preferredContentHeight)];
    [self.previewView setCenter:self.presentViewController.view.center];
    [UIView commitAnimations];

    // 添加 arrowup 图片
    UIImageView *arrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_up"]];
    [arrowImageView setFrame:CGRectMake(self.presentViewController.view.center.x - 17,
                                        previewViewFrame.origin.y - 20,
                                        34, 11)];
    [self.scrollView addSubview:arrowImageView];
}

- (void)setBtnView{
    CGSize presentViewSize = presentViewFrame.size;
    CGFloat btnViewHeight = btnHeight*self.actionsArray.count;
    CGFloat leftHeight = presentViewSize.height - (previewViewFrame.origin.y - self.scrollView.contentOffset.y + previewViewFrame.size.height);
    
    self.isBtnViewExist = YES;
    [self.btnView setHidden:NO];
    
    if(leftHeight < btnViewHeight){
        // offset 不够时， btnView 跟在 scrollView 后面
        [self setBtnViewInScrollView];
    }else{
        // offset 足够， btnView 直接放在 self.view 底部
        [self setBtnViewInSelfView];
    }
}
- (void)showPreview{
    // 在上层 view 里加入视图
    [self.presentViewController.view addSubview:self.view];
    for (UIGestureRecognizer *gesture in self.presentViewController.view.gestureRecognizers){
        [gesture addTarget:self action:@selector(gestureAction:)];
    }
}
/**
 * 从上层视图继承的手势 selector
 */
-(void)gestureAction:(UIGestureRecognizer *)sender{
    // 第一次打开时的手指的位置
    if(!self.startOffset){
        self.startOffset = [sender locationInView:self.view].y;
    }
    // 计算移动的位移
    CGFloat contentOffset = self.startOffset - [sender locationInView:self.view].y;
    [self.scrollView setContentOffset:CGPointMake(0,contentOffset)];
    
    // 手指离开时的动作
    if(sender.state == UIGestureRecognizerStateEnded){
        [self gestureDidFinish];
    }
}

- (void)gestureDidFinish{
    if(!self.isBtnViewExist){
        [self dismiss];
    }else{
        // 回弹 scrollView
        [self scrollViewReplace];
    }
}

# pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 判断滑动方向
    BOOL ret = NO;
    static CGFloat newY = 0;
    static CGFloat oldY = 0;
    newY = scrollView.contentOffset.y;
    if (newY > oldY) {
        ret = YES; // 向上滑
    }else{
        ret = NO; // 向下滑
    }
    oldY = newY;
    

    CGSize presentViewSize = presentViewFrame.size;
    CGFloat leftHeight =  presentViewSize.height - previewViewFrame.size.height - previewViewFrame.origin.y - 20;
    
    BOOL isBtnViewOnBottom = NO;
    if(self.btnView.frame.origin.y == presentViewFrame.size.height - btnHeight*self.actionsArray.count - 20){
        isBtnViewOnBottom = YES;
    }
    
    // 第一次向上 offset 到 60
    if(ret && newY >= 60 && !self.isBtnViewExist){
        [self setBtnView];
        NSLog(@"第一次向上 offset 到 60");
    }
    
    // 移动到 btnView 完全显示出来
    else if(ret && newY > btnHeight*self.actionsArray.count + 20 - leftHeight && self.isBtnViewExist){
        [self setBtnViewInSelfView];
        NSLog(@"移动到 btnView 完全显示出来");
    }
    
    // btnView 已经固定在底部，并且偏移量到 btnView 上
    CGFloat offset = self.btnView.frame.size.height + previewViewFrame.origin.y + previewViewFrame.size.height - presentViewFrame.size.height;
    if(!ret && newY < offset + 40 && isBtnViewOnBottom && self.isBtnViewExist){
        [self setBtnViewInScrollView];
//        NSLog(@"btnView 已经固定在底部，并且偏移量到 btnView 上");
        return;
    }
    
    // 向下移动到 半个 btn 高度
    if(self.isBtnViewExist && !ret
       &&[self.btnView.superview isEqual:self.scrollView]
       &&newY < self.scrollView.contentSize.height - presentViewFrame.size.height - btnHeight/2 - 20){
        
//        NSLog(@"向下移动到 半个 btn 高度");
    }
}
# pragma mark - Getter and Setter
- (UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc]initWithFrame:presentViewFrame];
        // 隐藏两条滚动条
        _scrollView.showsVerticalScrollIndicator = FALSE;
        _scrollView.showsHorizontalScrollIndicator = FALSE;
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(presentViewFrame.size.width, presentViewFrame.size.height);
        _scrollView.bounces = YES;
        _scrollView.scrollEnabled = YES;
        [_scrollView setContentInset:UIEdgeInsetsMake(10, 0, 10, 0)];
        [_scrollView setContentOffset:CGPointMake(0, 0)];
        [_scrollView addSubview:self.previewView];
    }
    return _scrollView;
}
- (UIView *)btnView{
    if(!_btnView){
        _btnView = [[UIView alloc]init];
        [_btnView.layer setCornerRadius:10];
        [_btnView setClipsToBounds:YES];
        [_btnView setBackgroundColor:[UIColor whiteColor]];
        // 遍历 action 生成对应 button
        NSInteger index = 0;
        for (JHPreviewAciton *action in self.actionsArray){
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, index*btnHeight, previewViewFrame.size.width, btnHeight)];
            [btn.layer setBorderWidth:0.5];
            [btn setTitle:action.title forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:0.0f/255.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
            [btn handleControlEvent:UIControlEventAllEvents withBlock:action.handler];
            [_btnView addSubview:btn];
            index++;
        }
        [_btnView setHidden:YES];
    }
    return _btnView;
}
# pragma mark -
- (void)setBtnViewInSelfView{
    CGSize size = presentViewFrame.size;
    [self.btnView setFrame:CGRectMake(previewViewFrame.origin.x,
                                      size.height - btnHeight*self.actionsArray.count - 20,
                                      previewViewFrame.size.width,
                                      btnHeight*self.actionsArray.count)];
    [self.btnView removeFromSuperview];
    [self.view addSubview:self.btnView];
}
- (void)setBtnViewInScrollView{
    [self.btnView setFrame:CGRectMake(previewViewFrame.origin.x,
                                      previewViewFrame.origin.y + previewViewFrame.size.height + 20,
                                      previewViewFrame.size.width,
                                      btnHeight*self.actionsArray.count)];
    self.scrollView.contentSize = CGSizeMake(presentViewFrame.size.width,
                                             self.btnView.frame.size.height + self.btnView.frame.origin.y + 20);
    [self.btnView removeFromSuperview];
    [self.scrollView addSubview:self.btnView];
}

- (void)scrollViewReplace{
    CGFloat offset = self.scrollView.contentSize.height - presentViewFrame.size.height;;
    [UIView animateWithDuration:0.4f animations:^{
        [self.scrollView setContentOffset:CGPointMake(0, offset)];
    } completion:^(BOOL finished) {
//        [self setBtnViewInScrollView];
//        [self.scrollView setContentOffset:CGPointMake(0, offset)];
    }];
}
- (void)dismiss{
    [self.view removeFromSuperview];
}

@end
