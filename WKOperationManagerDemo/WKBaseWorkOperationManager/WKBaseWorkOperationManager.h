//
//  WKBaseWorkOperationManager.h
//  JanesiBrowser
//
//  Created by mc on 2018/5/30.
//  Copyright © 2018年 weaken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKWorkOperation.h"

@interface WKBaseWorkOperationManager : NSObject

+ (WKBaseWorkOperationManager *)shareManager;

- (void)startRun;

- (void)endRun;

- (WKWorkOperation *)addOperation:(void(^)(WKWorkOperation *op))operation;

- (void)cancelAll;

- (void)cancelOpration:(WKWorkOperation *)opration;

@end
