//
//  BocHttpChainRequest.m
//  BocHttpManager
//
//  Created by Lixiaopeng on 2019/1/28.
//  Copyright © 2019 bocweb. All rights reserved.
//

#import "BocHttpChainRequest.h"
#import "BocHttpRequest.h"
#import "BocHttpResponse.h"

@interface BocHttpChainRequest()

@property (nonatomic, strong) NSMutableArray<BocNextBlock> *nextBlockArray;

@property (nonatomic, strong) NSMutableArray<BocHttpResponse *> *responseArray;

@property (nonatomic, copy) BocGroupResponseBlock completeBlock;

@end

@implementation BocHttpChainRequest

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    _responseArray = [NSMutableArray array];
    _nextBlockArray = [NSMutableArray array];
    return self;
}

- (BocHttpChainRequest *)onFirst:(BocRequestConfigBlock)firstBlock {
    NSAssert(firstBlock != nil, @"The first block for chain requests can't be nil.");
    NSAssert(_nextBlockArray.count == 0, @"The `-onFirst:` method must called befault `-onNext:` method");
    _runningRequest = [BocHttpRequest new];
    firstBlock(_runningRequest);
    return self;
}

- (BocHttpChainRequest *)onNext:(BocNextBlock)nextBlock {
    NSAssert(nextBlock != nil, @"The next block for chain requests can't be nil.");
    [_nextBlockArray addObject:nextBlock];
    return self;
}

- (BOOL)onFinishedOneRequest:(BocHttpRequest *)request
                    response:(nullable BocHttpResponse *)responseObject {
    BOOL isFinished = NO;
    [_responseArray addObject:responseObject];
    // 失败
    if (responseObject.status == BocHttpResponseStatusError) {
        _completeBlock(_responseArray.copy, NO);
        [self cleanCallbackBlocks];
        isFinished = YES;
        return isFinished;
    }
    // 正常完成
    if (_responseArray.count > _nextBlockArray.count) {
        _completeBlock(_responseArray.copy, YES);
        [self cleanCallbackBlocks];
        isFinished = YES;
        return isFinished;
    }
    /// 继续运行
    _runningRequest = [BocHttpRequest new];
    BocNextBlock nextBlock = _nextBlockArray[_responseArray.count - 1];
    BOOL isSent = YES;
    nextBlock(_runningRequest, responseObject, &isSent);
    if (!isSent) {
        _completeBlock(_responseArray.copy, YES);
        [self cleanCallbackBlocks];
        isFinished = YES;
    }
    return isFinished;
}

- (void)cleanCallbackBlocks {
    _runningRequest = nil;
    _completeBlock = nil;
    [_nextBlockArray removeAllObjects];
}

@end
