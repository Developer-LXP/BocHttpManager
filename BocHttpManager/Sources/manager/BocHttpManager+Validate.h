//
//  BocHttpManager+Validate.h
//  BocHttpManager
//
//  Created by Lixiaopeng on 2019/1/28.
//  Copyright © 2019 bocweb. All rights reserved.
//

#import "BocHttpManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface BocHttpManager (Validate)

/**
 请求前的拦截器
 
 @param cls 实现 HKRequestInterceptorProtocol 协议的 实体类
 可以在该实体类中做请求前的处理
 */
+ (void)registerRequestInterceptor:(nonnull Class)cls;

+ (void)unregisterRequestInterceptor:(nonnull Class)cls;

/**
 返回数据前的拦截器
 
 @param cls 实现 HKResponseInterceptorProtocol 协议的 实体类
 可以在该实体类中做统一的数据验证
 */
+ (void)registerResponseInterceptor:(nonnull Class)cls;

+ (void)unregisterResponseInterceptor:(nonnull Class)cls;

@end

NS_ASSUME_NONNULL_END
