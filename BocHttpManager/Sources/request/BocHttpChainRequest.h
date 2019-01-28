//
//  BocHttpChainRequest.h
//  BocHttpManager
//
//  Created by Lixiaopeng on 2019/1/28.
//  Copyright © 2019 bocweb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BocHttpConstant.h"
@class BocHttpRequest, BocHttpResponse;

NS_ASSUME_NONNULL_BEGIN

@interface BocHttpChainRequest : NSObject

@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, strong, readonly) BocHttpRequest *runningRequest;

- (BocHttpChainRequest *)onFirst:(BocRequestConfigBlock)firstBlock;

- (BocHttpChainRequest *)onNext:(BocNextBlock)nextBlock;

- (BOOL)onFinishedOneRequest:(BocHttpRequest *)request response:(nullable BocHttpResponse *)responseObject;

@end

NS_ASSUME_NONNULL_END
