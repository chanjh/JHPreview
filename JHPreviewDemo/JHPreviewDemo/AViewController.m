//
//  AViewController.m
//  previewTest
//
//  Created by 陈嘉豪 on 2017/4/27.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import "AViewController.h"

@interface AViewController ()

@end

@implementation AViewController

-(instancetype)init{
    if(self = [super init]){
        CGRect frame = [UIScreen mainScreen].bounds;
        [self.view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
