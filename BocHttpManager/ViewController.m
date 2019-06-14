//
//  ViewController.m
//  BocHttpManager
//
//  Created by Lixiaopeng on 2019/1/28.
//  Copyright © 2019 bocweb. All rights reserved.
//

#import "ViewController.h"
#import "BocHttpManagerHeader.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //https://www.apiopen.top/
    //http://demo2.yunmofo.cn/ggzs/index.php/api/
    [BocHttpConfigure shareInstance].generalServer = @"http://demo2.yunmofo.cn/ggzs/index.php/api/";
    [BocHttpConfigure addGeneralParameter:@"authorization" value:@"token"];
    [BocHttpConfigure addGeneralParameter:@"platform" value:@(0)];
    
    [self sendBasicRequest];
//    [self sendBasicRequestTwo];
//    [self sendBasicRequestThree];
//    [self sendChainRequest];
//    [self sendGroupRequest];
    [BocHttpConfigure shareInstance].enableDebug = YES;
}

/**
 基础请求
 */
- (void)sendBasicRequest {
    BocHttpRequest *request = [[BocHttpRequest alloc] init];
    request.requestURL = @"satinApi";
        //        request.normalParams = @{@"type":@"1",
        //                                 @"page":@"1"
        //                                 };
    [[BocHttpManager shareManager] sendRequest:request complete:^(BocHttpResponse * _Nullable response) {
        NSLog(@"%@",response.content);
    }];
}

- (void)sendBasicRequestTwo {
    BocHttpRequest *request = [[BocHttpRequest alloc] init];
    request.requestURL = @"satinApi";
    request.requestMethod = BocHttpRequestTypeGet;
    [[BocHttpManager shareManager] sendRequest:request complete:^(BocHttpResponse * _Nullable response) {
        NSLog(@"%@",response.content);
    }];
}

- (void)sendBasicRequestThree {
    BocHttpRequest *request = [[BocHttpRequest alloc] init];
    request.requestURL = @"satinApi";
    [[BocHttpManager shareManager] sendRequestWithConfigBlock:^(BocHttpRequest * _Nullable request) {
        request.requestURL = @"satinApi";
        request.normalParams = @{@"type":@"1",
                                 @"page":@"1"
                                 };
        request.requestMethod = BocHttpRequestTypeGet;
    } complete:^(BocHttpResponse * _Nullable response) {
        if (response.status == BocHttpResponseStatusSuccess) {
            NSLog(@"%@",response.content);
        }
    }];
}

/**
 队列请求
 */
- (void)sendChainRequest {
    [[BocHttpManager shareManager] sendChainRequest:^(BocHttpChainRequest * _Nullable chainRequest) {
        [chainRequest onFirst:^(BocHttpRequest * _Nullable request) {
            request.requestURL = @"satinApi";
            request.normalParams = @{@"type":@"1",
                                     @"page":@"1"
                                     };
            request.requestMethod = BocHttpRequestTypeGet;
        }];
        [chainRequest onNext:^(BocHttpRequest * _Nullable request, BocHttpResponse * _Nullable responseObject, BOOL * _Nullable isSent) {
            request.requestURL = @"satinApi";
            request.normalParams = @{@"type":@"1",
                                     @"page":@"2"
                                     };
            request.requestMethod = BocHttpRequestTypeGet;
        }];
        [chainRequest onNext:^(BocHttpRequest * _Nullable request, BocHttpResponse * _Nullable responseObject, BOOL * _Nullable isSent) {
            request.requestURL = @"satinApi";
            request.normalParams = @{@"type":@"1",
                                     @"page":@"3"
                                     };
            request.requestMethod = BocHttpRequestTypeGet;
        }];
        
    } complete:^(NSArray<BocHttpResponse *> * _Nullable responseObjects, BOOL isSuccess) {
        
    }];
}

- (void)sendGroupRequest {
    
    [[BocHttpManager shareManager] sendGroupRequest:^(BocHttpGroupRequest * _Nullable groupRequest) {
        for (NSInteger i = 0; i < 5; i ++) {
            BocHttpRequest *request = [[BocHttpRequest alloc] init];
            request.requestURL = @"satinApi";
            request.normalParams = @{@"type":@"1",
                                     @"page":@"1"
                                     };
            request.requestMethod = BocHttpRequestTypeGet;
            [groupRequest addRequest:request];
        }
    } complete:^(NSArray<BocHttpResponse *> * _Nullable responseObjects, BOOL isSuccess) {
        
    }];
}

@end
