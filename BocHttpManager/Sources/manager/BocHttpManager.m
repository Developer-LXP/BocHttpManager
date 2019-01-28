//
//  BocHttpManager.m
//  BocHttpManager
//
//  Created by Lixiaopeng on 2019/1/28.
//  Copyright © 2019 bocweb. All rights reserved.
//

#import "BocHttpManager.h"
#import <AFNetworking/AFNetworking.h>
#import "BocHttpManager+Validate.h"
#import "BocHttpLogger.h"
#import "BocHttpConfigure.h"
#import "BocHttpResponse.h"
#import "BocHttpRequest.h"

@implementation BocHttpManager

+ (void)load {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (nonnull instancetype)shareManager
{
    static dispatch_once_t onceToken;
    static BocHttpManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init{
    self = [super init];
    if (self)
    {
        _requestInterceptorObjectArray = [NSMutableArray arrayWithCapacity:3];
        _responseInterceptorObjectArray = [NSMutableArray arrayWithCapacity:3];
        _reqeustDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}
- (AFHTTPSessionManager *)sessionManager{
    if (_sessionManager == nil){
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPMaximumConnectionsPerHost = 4;
        _sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sessionManager.securityPolicy.allowInvalidCertificates = YES;
        _sessionManager.securityPolicy.validatesDomainName = NO;
    }
    return _sessionManager;
}
- (NSString *)sendRequest:(BocHttpRequest *)request complete:(BocHttpResponseBlock)result{
        //拦截器处理
    if (![self needRequestInterceptor:request]) {
        if ([BocHttpConfigure shareInstance].enableDebug) {
            NSLog(@"该请求已经取消");
            [BocHttpLogger logDebugInfoWithRequest:request];
        }
        return nil;
    }
    return [self requestWithRequest:[request generateRequest]  complete:result];
}
- (NSString *_Nullable)sendRequestWithConfigBlock:(nonnull BocRequestConfigBlock)requestBlock complete:(nonnull BocHttpResponseBlock) result{
    BocHttpRequest *request = [BocHttpRequest new];
    requestBlock(request);
        // 拦截器处理
    if (![self needRequestInterceptor:request])
    {
        if ([BocHttpConfigure shareInstance].enableDebug)
        {
            NSLog(@"该请求已经取消");
            [BocHttpLogger logDebugInfoWithRequest:request];
        }
        return nil;
    }
    return [self requestWithRequest:[request generateRequest] complete:result];
}


/**
 取消一个网络请求
 
 @param requestID 请求id
 */
- (void)cancelRequestWithRequestID:(nonnull NSString *)requestID{
    NSURLSessionDataTask *requestOperation = self.reqeustDictionary[requestID];
    [requestOperation cancel];
    [self.reqeustDictionary removeObjectForKey:requestID];
}


/**
 取消很多网络请求
 
 @param requestIDList @[请求id,请求id]
 */
- (void)cancelRequestWithRequestIDList:(nonnull NSArray<NSString *> *)requestIDList{
    for (NSString *requestId in requestIDList){
        [self cancelRequestWithRequestID:requestId];
    }
}
#pragma - private

/**
 发起请求
 
 @param request NSURLRequest
 @param complete 回调
 @return requestId
 */
- (NSString *)requestWithRequest:(NSURLRequest *)request complete:(BocHttpResponseBlock)complete{
        // 网络检查
    if (![[AFNetworkReachabilityManager sharedManager] isReachable] && [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusUnknown)
    {
        NSError *err = [NSError errorWithDomain:@"" code:AFNetworkReachabilityStatusUnknown userInfo:nil];
        BocHttpResponse *rsp = [[BocHttpResponse alloc] initWithRequestId:@(0) request:request responseData:nil error:err];
        for (id obj in self.responseInterceptorObjectArray)
        {
            if ([obj respondsToSelector:@selector(validatorResponse:)])
            {
                [obj validatorResponse:rsp];
                break;
            }
        }
        complete ? complete(rsp) : nil;
        return nil;
    }
    __block NSURLSessionDataTask *task = nil;
    task = [self.sessionManager dataTaskWithRequest:request
                                  completionHandler:^(NSURLResponse *_Nonnull response, id _Nullable responseObject, NSError *_Nullable error) {
                                      [self.reqeustDictionary removeObjectForKey:@([task taskIdentifier])];
                                      NSData *responseData = responseObject;
                                      [self requestFinishedWithBlock:complete task:task data:responseData error:error];
                                  }];
    
    NSString *requestId = [[NSString alloc] initWithFormat:@"%ld", [task taskIdentifier]];
    self.reqeustDictionary[requestId] = task;
    [task resume];
    return requestId;
}

- (void)requestFinishedWithBlock:(BocHttpResponseBlock)blk task:(NSURLSessionTask *)task data:(NSData *)data error:(NSError *)error
{
    if ([BocHttpConfigure shareInstance].enableDebug){
            //打印返回参数
        [BocHttpLogger logDebugInfoWithTask:task data:data error:error];
    }
    
    if (error){
        BocHttpResponse *rsp = [[BocHttpResponse alloc] initWithRequestId:@([task taskIdentifier]) request:task.originalRequest responseData:data error:error];
        for (id obj in self.responseInterceptorObjectArray)
        {
            if ([obj respondsToSelector:@selector(validatorResponse:)])
            {
                [obj validatorResponse:rsp];
                break;
            }
        }
        blk ? blk(rsp) : nil;
    }
    else{
        BocHttpResponse *rsp = [[BocHttpResponse alloc] initWithRequestId:@([task taskIdentifier]) request:task.originalRequest responseData:data status:BocHttpResponseStatusSuccess];
        for (id obj in self.responseInterceptorObjectArray)
        {
            if ([obj respondsToSelector:@selector(validatorResponse:)])
            {
                [obj validatorResponse:rsp];
                break;
            }
        }
        blk ? blk(rsp) : nil;
    }
}

- (BOOL)needRequestInterceptor:(BocHttpRequest *)request
{
    BOOL need = YES;
    for (id obj in self.requestInterceptorObjectArray){
        if ([obj respondsToSelector:@selector(needRequestWithRequest:)]){
            need = [obj needRequestWithRequest:request];
            if (need)
            {
                break;
            }
        }
    }
    return need;
}

@end
