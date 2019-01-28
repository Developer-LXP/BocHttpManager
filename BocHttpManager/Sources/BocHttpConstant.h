//
//  BocHttpConstant.h
//  BocHttpManager
//
//  Created by Lixiaopeng on 2019/1/28.
//  Copyright © 2019 bocweb. All rights reserved.
//

#ifndef BocHttpConstant_h
#define BocHttpConstant_h

#import "BocRequestInterceptorProtocol.h"
#import "BocResponseInterceptorProtocol.h"

@class BocHttpResponse, BocHttpRequest, BocHttpGroupRequest, BocHttpChainRequest;

/**
 *  请求类型
 */
typedef NS_ENUM (NSUInteger, BocHttpRequestType) {
    BocHttpRequestTypeGet,
    BocHttpRequestTypePost,
    BocHttpRequestTypePut,
    BocHttpRequestTypeDelete,
    BocHttpRequestTypePatch
};

/**
 *  响应类型
 */
typedef NS_ENUM (NSUInteger, BocHttpResponseStatus) {
    BocHttpResponseStatusError = 0,
    BocHttpResponseStatusSuccess = 1
};

///响应配置 Block
typedef void (^BocHttpResponseBlock)(BocHttpResponse * _Nullable response);

typedef void (^BocGroupResponseBlock)(NSArray<BocHttpResponse *> * _Nullable responseObjects, BOOL isSuccess);

typedef void (^BocNextBlock)(BocHttpRequest * _Nullable request, BocHttpResponse * _Nullable responseObject, BOOL * _Nullable isSent);

/// 请求配置 Block

typedef void (^BocRequestConfigBlock)(BocHttpRequest * _Nullable request);

typedef void (^BocGroupRequestConfigBlock)(BocHttpGroupRequest * _Nullable groupRequest);

typedef void (^BocChainRequestConfigBlock)(BocHttpChainRequest * _Nullable chainRequest);

#endif /* BocHttpConstant_h */
