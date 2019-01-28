//
//  BocHttpConfigure.m
//  BocHttpManager
//
//  Created by Lixiaopeng on 2019/1/28.
//  Copyright © 2019 bocweb. All rights reserved.
//

#import "BocHttpConfigure.h"

@implementation BocHttpConfigure

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static BocHttpConfigure *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _enableDebug = NO;
    }
    return self;
}

#pragma mark - interface
/**
 添加公共请求参数
 */
+ (void)addGeneralParameter:(NSString *)sKey value:(id)sValue {
    BocHttpConfigure *manager = [BocHttpConfigure shareInstance];
    NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
    mDict[sKey] = sValue;
    [mDict addEntriesFromDictionary:manager.generalParameters];
    manager.generalParameters = mDict.copy;
}

/**
 移除请求参数
 */
+ (void)removeGeneralParameter:(NSString *)sKey {
    BocHttpConfigure *manager = [BocHttpConfigure shareInstance];
    NSMutableDictionary *mDict = manager.generalParameters.mutableCopy;
    [mDict removeObjectForKey:sKey];
    manager.generalParameters = mDict.copy;
}

#pragma mark - private
- (NSString *)respondeSuccessCode {
    if (!_respondeSuccessCode) {
        _respondeSuccessCode = @"200";
    }
    return _respondeSuccessCode;
}

@end
