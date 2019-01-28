//
//  BocHttpLogger.h
//  BocHttpManager
//
//  Created by Lixiaopeng on 2019/1/28.
//  Copyright © 2019 bocweb. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BocHttpRequest;

NS_ASSUME_NONNULL_BEGIN

@interface BocHttpLogger : NSObject

/**
 输出签名
 */
+ (void)logSignInfoWithString:(NSString *)sign;

/**
 请求参数
 */
+ (void)logDebugInfoWithRequest:(BocHttpRequest *)request;

/**
 响应数据输出
 */
+ (void)logDebugInfoWithTask:(NSURLSessionTask *)sessionTask data:(NSData *)data error:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
