//
//  ViewController.m
//  JHPreviewDemo
//
//  Created by 陈嘉豪 on 2017/4/27.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import "ViewController.h"
#import "JHPreviewViewController.h"
#import "JHPeekViewController.h"
#import "JHPreviewAciton.h"
#import "AViewController.h"

@interface ViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) JHPreviewViewController *viewController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 长按手势
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGRAction:)];
    longPressGR.minimumPressDuration = 0.2; // 设置最短长按的时间
    [self.view addGestureRecognizer:longPressGR];
    [self.view setBackgroundColor:[UIColor redColor]];
}

-(void)longPressGRAction:(UILongPressGestureRecognizer *)sender{
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"BEGIN");
        JHPreviewAciton *action = [JHPreviewAciton actionWithTitle:@"ddd" actionStyle:JHPreviewAcionStyleDefault handler:nil];
        JHPreviewAciton *action2 = [JHPreviewAciton actionWithTitle:@"ddd" actionStyle:JHPreviewAcionStyleDefault handler:nil];
        AViewController *aVC = [[AViewController alloc]init];
        
        self.viewController = [[JHPreviewViewController alloc]initWithPresentViewController:self
                                                                               acitonsArray:@[action, action2]
                                                                                previewView:aVC.view
                                                                  andPreferredContentHeight:300];
        
        
        [self.viewController showPreview];
    }
    
    if(sender.state == UIGestureRecognizerStateEnded){
        NSLog(@"END");
    }
}

@end
