//
//  ViewController.m
//  WKOperationManagerDemo
//
//  Created by mac on 2018/7/25.
//  Copyright © 2018年 weikun. All rights reserved.
//

#import "ViewController.h"
#import "WKBaseWorkOperationManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    __block WKWorkOperation *operation4;
    
    [WKBaseWorkOperationManager.shareManager addOperation:^(WKWorkOperation *op) {
        [self showAlertWithTitle:@"弹框1" completed:^{
            [op wk_FinishOpeation];
        }];
    }];
    
    [WKBaseWorkOperationManager.shareManager addOperation:^(WKWorkOperation *op) {
        [self showAlertWithTitle:@"弹框2" completed:^{
            [op wk_FinishOpeation];
        }];
    }];
    
    [WKBaseWorkOperationManager.shareManager addOperation:^(WKWorkOperation *op) {
        [self showAlertWithTitle:@"弹框3" completed:^{
            [WKBaseWorkOperationManager.shareManager cancelOpration:operation4];
            [op wk_FinishOpeation];
        }];
    }];
    
    operation4 = [WKBaseWorkOperationManager.shareManager addOperation:^(WKWorkOperation *op) {
        [self showAlertWithTitle:@"弹框4" completed:^{
            [op wk_FinishOpeation];
        }];
    }];
    
    [WKBaseWorkOperationManager.shareManager addOperation:^(WKWorkOperation *op) {
        [self showAlertWithTitle:@"弹框5" completed:^{
            [op wk_FinishOpeation];
        }];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [WKBaseWorkOperationManager.shareManager startRun];
    });
}

- (void)showAlertWithTitle:(NSString *)title completed:(void(^)(void))completed {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completed();
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completed();
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
