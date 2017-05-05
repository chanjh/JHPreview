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
@property (weak, nonatomic) IBOutlet UITextField *textField;

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
        JHPreviewAciton *action = [JHPreviewAciton actionWithTitle:@"ddd" actionStyle:JHPreviewAcionStyleDefault handler:nil];
        
        AViewController *aVC = [[AViewController alloc]init];
        NSMutableArray *array = [NSMutableArray array];
        NSInteger num;
        if(self.textField.text.length){
            num = [self.textField.text integerValue];
        }else{
            num = 2;
        }
        for (int i = 0; i < num; i++){
            [array addObject:action];
        }
        self.viewController = [[JHPreviewViewController alloc]initWithPresentViewController:self
                                                                               acitonsArray:array
                                                                                previewView:aVC.view
                                                                  andPreferredContentHeight:300];
    
        [self.viewController showPreview];

    }
    
    if(sender.state == UIGestureRecognizerStateEnded){

    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
