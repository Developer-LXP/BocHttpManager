//
//  BocHttpConfigure.h
//  BocHttpManager
//
//  Created by Lixiaopeng on 2019/1/28.
//  Copyright © 2019 bocweb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BocHttpConfigure : NSObject

///公共参数
@property (nonatomic, strong, nullable) NSDictionary<NSString *, id> *generalParameters;

///公共请求头
@property (nonatomic, strong, nullable) NSDictionary<NSString *, NSString *> *generalHeaders;

///服务器地址 默认：
@property (nonatomic, copy, readwrite, nonnull) NSString *generalServer;

///与后端约定的请求成功Code
@property (nonatomic,copy)NSString *respondeSuccessCode;

///是否为调试模式（默认 false, 当为 true 时，会输出 网络请求日志）
@property (nonatomic, readwrite) BOOL enableDebug;

+ (_Nonnull instancetype)shareInstance;

/**
 添加公共请求参数
 */
+ (void)addGeneralParameter:(NSString * _Nonnull)sKey value:(id _Nonnull )sValue;

/**
 移除请求参数
 */
+ (void)removeGeneralParameter:(NSString * _Nonnull)sKey;

@end

NS_ASSUME_NONNULL_END
