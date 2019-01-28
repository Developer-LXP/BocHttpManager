//
//  BocHttpManager+Group.h
//  BocHttpManager
//
//  Created by Lixiaopeng on 2019/1/28.
//  Copyright © 2019 bocweb. All rights reserved.
//

#import "BocHttpManager.h"
#import "BocHttpConstant.h"

NS_ASSUME_NONNULL_BEGIN

@interface BocHttpManager (Group)

- (NSString *)sendGroupRequest:(nullable BocGroupRequestConfigBlock)configBlock
                      complete:(nullable BocGroupResponseBlock)completeBlock;

- (void)cancelGroupRequest:(NSString *)taskID;

@end

NS_ASSUME_NONNULL_END
