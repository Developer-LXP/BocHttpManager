//
//  BocHttpResponse.h
//  BocHttpManager
//
//  Created by Lixiaopeng on 2019/1/28.
//  Copyright © 2019 bocweb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BocHttpConstant.h"

NS_ASSUME_NONNULL_BEGIN

@interface BocHttpResponse : NSObject

/**
 * 原始数据
 */
@property (nullable, nonatomic, copy, readonly) NSData *rawData;

/**
 * 请求状态
 */
@property (nonatomic, assign, readonly) BocHttpResponseStatus status;

/**
 * 请求内容
 */
@property (nullable, nonatomic, copy, readonly) id content;

/**
 * 状态码
 */
@property (nonatomic, assign, readonly) NSInteger statusCode;

@property (nonatomic, assign, readonly) NSInteger requestId;

@property (nonnull, nonatomic, copy, readonly) NSURLRequest *request;

- (nonnull instancetype)initWithRequestId:(nonnull NSNumber *)requestId
                                  request:(nonnull NSURLRequest *)request
                             responseData:(nullable NSData *)responseData
                                   status:(BocHttpResponseStatus)status;

- (nonnull instancetype)initWithRequestId:(nonnull NSNumber *)requestId
                                  request:(nonnull NSURLRequest *)request
                             responseData:(nullable NSData *)responseData
                                    error:(nullable NSError *)error;

@end

NS_ASSUME_NONNULL_END
