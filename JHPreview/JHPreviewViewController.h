//
//  JHPreviewViewController.h
//  previewTest
//
//  Created by 陈嘉豪 on 2017/4/26.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHPeekViewController;
@class JHPreviewAciton;
@interface JHPreviewViewController : UIViewController

/**
 * 传入一个 PeekViewController 对象
 * 包含对应的 Action 对象和 View 对象
 */
- (instancetype)initWithShowViewController:(__kindof UIViewController *)showViewController
                 withPresentViewController:(UIViewController *)presentViewController
                     andPeekViewController:(__kindof JHPeekViewController *)peekViewController;

/**
 * 传入对应的 Action 对象和 View 对象
 */
- (instancetype)initWithPresentViewController:(__kindof UIViewController *)presentViewController
                              acitonsArray:(NSArray <JHPreviewAciton *>*)actionsArray
                               previewView:(__kindof UIView *)previewView
                   andPreferredContentHeight:(CGFloat)height;
/**
 * 展示 Preview 视图
 */
- (void)showPreview;

@end
