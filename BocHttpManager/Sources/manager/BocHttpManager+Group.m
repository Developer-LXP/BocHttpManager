//
//  BocHttpManager+Group.m
//  BocHttpManager
//
//  Created by Lixiaopeng on 2019/1/28.
//  Copyright © 2019 bocweb. All rights reserved.
//

#import "BocHttpManager+Group.h"
#import "BocHttpGroupRequest.h"
#import "BocHttpRequest.h"
#import <objc/runtime.h>

@implementation BocHttpManager (Group)

- (NSMutableDictionary *)groupRequestDictionary {
    return objc_getAssociatedObject(self, @selector(groupRequestDictionary));
}

- (void)setGroupRequestDictionary:(NSMutableDictionary *)mutableDictionary {
    objc_setAssociatedObject(self, @selector(groupRequestDictionary), mutableDictionary, OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)sendGroupRequest:(nullable BocGroupRequestConfigBlock)configBlock
                      complete:(nullable BocGroupResponseBlock)completeBlock {
    
    if (![self groupRequestDictionary]) {
        [self setGroupRequestDictionary:[[NSMutableDictionary alloc] init]];
    }
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    BocHttpGroupRequest *groupRequest = [[BocHttpGroupRequest alloc] init];
    configBlock(groupRequest);
    
    if (groupRequest.requestArray.count > 0) {
        if (completeBlock) {
            [groupRequest setValue:completeBlock forKey:@"_completeBlock"];
        }
        
        [groupRequest.responseArray removeAllObjects];
        for (BocHttpRequest *request in groupRequest.requestArray) {
            
            NSString *taskID = [self sendRequest:request complete:^(BocHttpResponse * _Nullable response) {
                if ([groupRequest onFinishedOneRequest:request response:response]) {
                    NSLog(@"finish");
                }
            }];
            [tempArray addObject:taskID];
        }
        NSString *uuid = [[NSUUID UUID].UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [self groupRequestDictionary][uuid] = tempArray.copy;
        return uuid;
    }
    return nil;
}

- (void)cancelGroupRequest:(NSString *)taskID {
    NSArray *group = [self groupRequestDictionary][taskID];
    for (NSString *tid in group) {
        [self cancelRequestWithRequestID:tid];
    }
}

@end
