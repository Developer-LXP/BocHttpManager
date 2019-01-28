# BocHttpManager

###### 博采网络工具最初原型参考HKHttpManager而来

###### 设置服务器地址
`[BocHttpConfigure shareInstance].generalServer = @"https://www.apiopen.top/";`

###### 发送普通请求
```
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
```

###### 发送队列请求

```
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
```
