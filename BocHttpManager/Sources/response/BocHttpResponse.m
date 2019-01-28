//
//  BocHttpResponse.m
//  BocHttpManager
//
//  Created by Lixiaopeng on 2019/1/28.
//  Copyright © 2019 bocweb. All rights reserved.
//

#import "BocHttpResponse.h"
#import "BocHttpConfigure.h"

@interface BocHttpResponse ()

@property (nonatomic, copy, readwrite) NSData *rawData;
@property (nonatomic, assign, readwrite) BocHttpResponseStatus status;
@property (nonatomic, copy, readwrite) id content;
@property (nonatomic, assign, readwrite) NSInteger statusCode;
@property (nonatomic, assign, readwrite) NSInteger requestId;
@property (nonatomic, copy, readwrite) NSURLRequest *request;

@end

@implementation BocHttpResponse

- (nonnull instancetype)initWithRequestId:(nonnull NSNumber *)requestId
                                  request:(nonnull NSURLRequest *)request
                             responseData:(nullable NSData *)responseData
                                   status:(BocHttpResponseStatus)status {
    self = [super init];
    if (self)
    {
        self.requestId = [requestId unsignedIntegerValue];
        self.request = request;
        self.rawData = responseData;
        [self inspectionResponse:nil];
    }
    return self;
}

- (nonnull instancetype)initWithRequestId:(nonnull NSNumber *)requestId
                                  request:(nonnull NSURLRequest *)request
                             responseData:(nullable NSData *)responseData
                                    error:(nullable NSError *)error {
    self = [super init];
    if (self)
    {
        self.requestId = [requestId unsignedIntegerValue];
        self.request = request;
        self.rawData = responseData;
        [self inspectionResponse:error];
    }
    return self;
}

- (id)jsonWithData:(NSData *)data {
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
}

#pragma mark - Private methods
- (void)inspectionResponse:(NSError *)error
{
    if (error)
    {
        self.status = BocHttpResponseStatusError;
        self.content = @"网络异常，请稍后再试";
        self.statusCode = error.code;
        return;
    }
    
    if (self.rawData.length > 0)
    {
        NSDictionary *dic = [self jsonWithData:self.rawData];
        BOOL result = NO;
        if ([dic[@"code"] isMemberOfClass:[NSString class]]) {
            result = [dic[@"code"] isEqualToString:[BocHttpConfigure shareInstance].respondeSuccessCode];
        }else if ([dic[@"code"] isMemberOfClass:[NSNumber class]]){
            result = [dic[@"code"] integerValue] == [[BocHttpConfigure shareInstance].respondeSuccessCode integerValue];
        }
        
        if (result)
        {
            self.status = BocHttpResponseStatusSuccess;
            self.content = [self processCotnentValue:dic];
            NSString *code = dic[@"code"];
            if (code && [code isKindOfClass:[NSString class]]) {
                self.statusCode = ((NSString*)code).integerValue;
            }
        }
        else
        {
            self.status = BocHttpResponseStatusError;
            self.content = dic[@"msg"];
            NSString *code = dic[@"code"];
            if (code && [code isKindOfClass:[NSString class]]) {
                self.statusCode = ((NSString*)code).integerValue;
            }
            if (![self.content isKindOfClass:[NSString class]]) {
                self.content = @"未知错误";
            }
        }
    }
    else
    {
        self.statusCode = NSURLErrorUnknown;
        self.status = BocHttpResponseStatusError;
        self.content = @"未知错误";
    }
    
}

/**
 临时 返回数据处理
 */
- (id)processCotnentValue:(id)content
{
    if ([content isKindOfClass:[NSDictionary class]])
    {
        NSMutableDictionary *contentDict = ((NSDictionary *)content).mutableCopy;
        [contentDict removeObjectForKey:@"result"];
        //        [contentDict removeObjectForKey:@"msg"];
        
        if ([contentDict[@"data"] isKindOfClass:[NSNull class]])
        {
            [contentDict removeObjectForKey:@"data"];
        }
        
        return contentDict.copy;
    }
    return content;
}

@end
