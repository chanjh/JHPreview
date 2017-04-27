//
//  JHPreviewAciton.m
//  previewTest
//
//  Created by 陈嘉豪 on 2017/4/26.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import "JHPreviewAciton.h"

@interface JHPreviewAciton()

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) void(^handler)();

@end

@implementation JHPreviewAciton


+(instancetype)actionWithTitle:(NSString *)title actionStyle:(JHPreviewAcionStyle)style handler:(void (^) ())handler{
    JHPreviewAciton *action = [[JHPreviewAciton alloc]init];
    
    action.title = title;
    action.handler = handler;
    
    return action;
}

@end
