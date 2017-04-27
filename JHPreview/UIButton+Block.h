//
//  UIButton+Block.h
//  previewTest
//
//  Created by 陈嘉豪 on 2017/4/27.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

typedef void (^ActionBlock)();

@interface UIButton(Block)

@property (readonly) NSMutableDictionary *event;

- (void) handleControlEvent:(UIControlEvents)controlEvent withBlock:(ActionBlock)action;

@end
