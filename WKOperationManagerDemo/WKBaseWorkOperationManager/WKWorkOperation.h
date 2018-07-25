//
//  WKWorkOperation.h
//  JanesiBrowser
//
//  Created by mc on 2018/5/30.
//  Copyright © 2018年 weaken. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKWorkOperation : NSOperation

@property (nonatomic, copy) NSString *oprationIdentifier;

- (instancetype)initWithBlock:(void(^)(WKWorkOperation *op))block
                     finished:(void(^)(WKWorkOperation *op))finishedBlock;

- (void)wk_FinishOpeation;

@end
