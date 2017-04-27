//
//  JHPeekViewController.h
//  previewTest
//
//  Created by 陈嘉豪 on 2017/4/26.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHPreviewAciton.h"

@interface JHPeekViewController : UIViewController

- (instancetype)initWithPreferredContentSize:(CGSize)size
                                actionsArray:(NSArray <JHPreviewAciton *> *)previewActions;

@property (nonatomic, strong, readonly) NSArray <JHPreviewAciton *> *previewActions;

@end
