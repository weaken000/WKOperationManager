//
//  WKBaseWorkOperationManager.m
//  JanesiBrowser
//
//  Created by mc on 2018/5/30.
//  Copyright © 2018年 weaken. All rights reserved.
//

#import "WKBaseWorkOperationManager.h"

#import "WKWorkOperation.h"

@interface WKBaseWorkOperationManager()

@property (nonatomic, strong) NSOperationQueue *sigleSerialQueue;

@property (nonatomic, strong) NSMutableArray<WKWorkOperation *> *serialOperations;

@end

@implementation WKBaseWorkOperationManager

+ (WKBaseWorkOperationManager *)shareManager {
    static WKBaseWorkOperationManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [WKBaseWorkOperationManager new];
        }
    });
    return instance;
}

- (instancetype)init {
    if (self == [super init]) {
        _serialOperations = [NSMutableArray array];
        _sigleSerialQueue = [NSOperationQueue new];
        _sigleSerialQueue.maxConcurrentOperationCount = 1;
        [_sigleSerialQueue setSuspended:YES];
    }
    return self;
}

- (void)startRun {
    if (!self.sigleSerialQueue.operations.count) return;
    if (self.sigleSerialQueue.isSuspended) {
        [self.sigleSerialQueue setSuspended:NO];
    }
}

- (void)endRun {
    if (!self.sigleSerialQueue.isSuspended) {
        [self.sigleSerialQueue setSuspended:YES];
    }
}

- (WKWorkOperation *)addOperation:(void (^)(WKWorkOperation *))operation {
    if (!operation) return nil;
    
    void (^ opCopy)(WKWorkOperation *) = [operation copy];
    
    __weak typeof(self) weakSelf = self;
    WKWorkOperation *op = [[WKWorkOperation alloc] initWithBlock:^(WKWorkOperation *blockOp) {
        opCopy(blockOp);
    } finished:^(WKWorkOperation *blockOp) {
        [weakSelf.serialOperations removeObject:blockOp];
    }];
    
    op.oprationIdentifier = [NSUUID UUID].UUIDString;
    
    [self.sigleSerialQueue addOperation:op];
    [self.serialOperations addObject:op];
    return op;
}

- (void)cancelAll {
    [self.sigleSerialQueue cancelAllOperations];
    [self.serialOperations removeAllObjects];
}

- (void)cancelOpration:(WKWorkOperation *)opration {
    WKWorkOperation *cancelOp;
    for (WKWorkOperation *op in self.serialOperations) {
        if ([op.oprationIdentifier isEqualToString:opration.oprationIdentifier]) {
            cancelOp = op;
            break;
        }
    }
    if (cancelOp) {
        [cancelOp wk_FinishOpeation];
    }
}

@end
