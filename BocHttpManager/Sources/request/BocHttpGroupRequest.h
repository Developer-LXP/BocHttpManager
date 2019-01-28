//
//  BocHttpGroupRequest.h
//  BocHttpManager
//
//  Created by Lixiaopeng on 2019/1/28.
//  Copyright © 2019 bocweb. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BocHttpRequest, BocHttpResponse;

NS_ASSUME_NONNULL_BEGIN

@interface BocHttpGroupRequest : NSObject

@property (nonatomic, strong, readonly) NSMutableArray<BocHttpRequest *> *requestArray;
@property (nonatomic, strong, readonly) NSMutableArray<BocHttpResponse *> *responseArray;

- (void)addRequest:(BocHttpRequest *)request;

- (BOOL)onFinishedOneRequest:(BocHttpRequest *)request response:(nullable BocHttpResponse *)responseObject;

@end

NS_ASSUME_NONNULL_END
