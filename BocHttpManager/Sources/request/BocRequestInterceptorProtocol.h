//
//  BocRequestInterceptorProtocol.h
//  BocHttpManager
//
//  Created by Lixiaopeng on 2019/1/28.
//  Copyright © 2019 bocweb. All rights reserved.
//
#import <Foundation/Foundation.h>
@class BocHttpRequest;

/**
 请求前的拦截协议
 */
@protocol BocRequestInterceptorProtocol <NSObject>

- (BOOL)needRequestWithRequest:(BocHttpRequest *)request;

- (NSData *)cacheDataFromRequest:(BocHttpRequest *)request;

@end
