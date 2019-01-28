//
//  BocHttpManager+Validate.m
//  BocHttpManager
//
//  Created by Lixiaopeng on 2019/1/28.
//  Copyright © 2019 bocweb. All rights reserved.
//

#import "BocHttpManager+Validate.h"

@implementation BocHttpManager (Validate)

+ (void)registerResponseInterceptor:(nonnull Class)cls {
    if (![cls conformsToProtocol:@protocol(BocResponseInterceptorProtocol)])
    {
        return;
    }
    
    [BocHttpManager unregisterResponseInterceptor:cls];
    
    BocHttpManager *share = [BocHttpManager shareManager];
    [share.responseInterceptorObjectArray addObject:[cls new]];
}

+ (void)unregisterResponseInterceptor:(nonnull Class)cls {
    BocHttpManager *share = [BocHttpManager shareManager];
    
    for (id obj in share.responseInterceptorObjectArray)
    {
        if ([obj isKindOfClass:[cls class]])
        {
            [share.responseInterceptorObjectArray removeObject:obj];
            break;
        }
    }
}

+ (void)registerRequestInterceptor:(nonnull Class)cls {
    if (![cls conformsToProtocol:@protocol(BocRequestInterceptorProtocol)])
    {
        return;
    }
    
    [BocHttpManager unregisterRequestInterceptor:cls];
    
    BocHttpManager *share = [BocHttpManager shareManager];
    [share.requestInterceptorObjectArray addObject:[cls new]];
}

+ (void)unregisterRequestInterceptor:(nonnull Class)cls {
    BocHttpManager *share = [BocHttpManager shareManager];
    for (id obj in share.requestInterceptorObjectArray)
    {
        if ([obj isKindOfClass:[cls class]])
        {
            [share.requestInterceptorObjectArray removeObject:obj];
            break;
        }
    }
}

@end
