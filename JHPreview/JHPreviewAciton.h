//
//  JHPreviewAciton.h
//  previewTest
//
//  Created by 陈嘉豪 on 2017/4/26.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JHPreviewAcionStyle) {
    JHPreviewAcionStyleDefault,
    JHPreviewAcionStyleCancle,
};


@interface JHPreviewAciton : NSObject

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) void(^handler)();

+(instancetype)actionWithTitle:(NSString *)title actionStyle:(JHPreviewAcionStyle)style handler:(void (^) ())handler;

@end
