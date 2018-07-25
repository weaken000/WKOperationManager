//
//  WKWorkOperation.m
//  JanesiBrowser
//
//  Created by mc on 2018/5/30.
//  Copyright © 2018年 weaken. All rights reserved.
//

#import "WKWorkOperation.h"

@interface WKWorkOperation()
@property (nonatomic, copy) void(^ operationBlock)(WKWorkOperation *op);
@property (nonatomic, copy) void(^ finishedBlock)(WKWorkOperation *op);
@end

@implementation WKWorkOperation {
    BOOL executing;
    BOOL finished;
    
    BOOL hasStart;
    BOOL needExecuting;
}


- (instancetype)initWithBlock:(void (^)(WKWorkOperation *))block finished:(void (^)(WKWorkOperation *))finishedBlock {
    if (self == [super init]) {
        self.operationBlock = [block copy];
        self.finishedBlock  = [finishedBlock copy];
        executing = NO;
        finished = NO;
        hasStart = NO;
        needExecuting = YES;
    }
    return self;
}

- (BOOL)isConcurrent {
    return YES;
}
- (BOOL)isExecuting {
    return executing;
}
- (BOOL)isFinished {
    return finished;
}

- (void)start {
    hasStart = YES;
    if ([self isCancelled]) {
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        if (self.finishedBlock) {
            self.finishedBlock(self);
            self.finishedBlock = nil;
        }
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    if (needExecuting) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.operationBlock) {
                self.operationBlock(self);
                self.operationBlock = nil;
            }
        });
    } else {
        self.operationBlock = nil;
        [self cancel];
        if (self.finishedBlock) {
            self.finishedBlock(self);
            self.finishedBlock = nil;
        }
    }
}

- (void)main {
    
}

- (void)wk_FinishOpeation {
    if (!hasStart) {
        needExecuting = NO;
        [self start];
        return;
    }
    
    if ([self isCancelled]) return;

    if (!finished) {
        [self willChangeValueForKey:@"isFinished"];
        [self willChangeValueForKey:@"isExecuting"];
        
        executing = NO;
        finished = YES;

        [self didChangeValueForKey:@"isExecuting"];
        [self didChangeValueForKey:@"isFinished"];

        if (self.finishedBlock) {
            self.finishedBlock(self);
            self.finishedBlock = nil;
        }
    }
}

@end
