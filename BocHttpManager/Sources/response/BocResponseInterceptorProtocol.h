//
//  BocResponseInterceptorProtocol.h
//  BocHttpManager
//
//  Created by Lixiaopeng on 2019/1/28.
//  Copyright © 2019 bocweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BocHttpResponse;

/**
 网络响应返回前的拦截协议
 */
@protocol BocResponseInterceptorProtocol <NSObject>

- (void)validatorResponse:(BocHttpResponse *)rsp;

@end
