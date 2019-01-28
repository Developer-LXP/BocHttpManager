//
//  BocHttpRequest.h
//  BocHttpManager
//
//  Created by Lixiaopeng on 2019/1/28.
//  Copyright © 2019 bocweb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BocHttpConstant.h"

NS_ASSUME_NONNULL_BEGIN

/**
 网络请求参数数据类
 */
@interface BocHttpRequest : NSObject

/**
 请求 Base URL，优先级高于 [HKHttpConfigure generalServer];
 */
@property (nonatomic, copy) NSString *baseURL;

/**
 请求路径 eg: /login2
 */
@property (nonatomic, copy) NSString *requestURL;

/**
 请求头，默认为空 @{}
 */
@property (nonatomic, strong) NSDictionary *requestHeader;

/**
 请求参数，加密参数 默认为空 @{}
 */
@property (nonatomic, strong) NSDictionary *encryptParams;

/**
 请求参数，不用加密 默认为 @{}
 */
@property (nonatomic, strong) NSDictionary *normalParams;

/**
 请求方式 默认为 HKRequestTypePost
 */
@property (nonatomic, assign) BocHttpRequestType requestMethod;


/**
 请求方式string
 */
@property (nonatomic,copy) NSString *requestMethodName;

/**
 请求超时时间 默认 30s
 */
@property (nonatomic, assign) NSTimeInterval reqeustTimeoutInterval;

/**
 api 版本号，默认 1.0
 */
@property (nonatomic, copy) NSString *apiVersion;

/**
 重试次数，默认为 0
 */
@property (nonatomic, assign) UInt8 retryCount NS_UNAVAILABLE;

/**
 生成请求
 
 @return NSURLRequest
 */
- (NSURLRequest *)generateRequest;

@end

NS_ASSUME_NONNULL_END
