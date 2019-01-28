//
//  BocHttpGroupRequest.m
//  BocHttpManager
//
//  Created by Lixiaopeng on 2019/1/28.
//  Copyright © 2019 bocweb. All rights reserved.
//

#import "BocHttpGroupRequest.h"

#import "BocHttpConstant.h"
#import "BocHttpResponse.h"

@interface BocHttpGroupRequest()

@property (nonatomic, strong) dispatch_semaphore_t lock;

@property (nonatomic, assign) NSUInteger finishedCount;

@property (nonatomic, assign, getter=isFailed) BOOL failed;

@property (nonatomic, copy) BocGroupResponseBlock completeBlock;
@end

@implementation BocHttpGroupRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        _requestArray = [NSMutableArray new];
        _responseArray = [NSMutableArray new];
    }
    return self;
}

- (void)addRequest:(BocHttpRequest *)request {
    [_requestArray addObject:request];
}

- (BOOL)onFinishedOneRequest:(BocHttpRequest *)request response:(nullable BocHttpResponse *)responseObject {
    BOOL isFinished = NO;
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    if (responseObject) {
        [_responseArray addObject:responseObject];
    }
    _failed |= (responseObject.status == BocHttpResponseStatusError);
    
    _finishedCount ++;
    if (_finishedCount == _requestArray.count) {
        if (_completeBlock) {
            _completeBlock(_responseArray.copy, !_failed);
        }
        [self cleanCallbackBlocks];
        isFinished = YES;
    }
    dispatch_semaphore_signal(_lock);
    return isFinished;
}

- (void)cleanCallbackBlocks {
    _completeBlock = nil;
}

#pragma mark - lazy load
- (dispatch_semaphore_t)lock {
    if (!_lock) {
        _lock = dispatch_semaphore_create(1);
    }
    return _lock;
}

@end
