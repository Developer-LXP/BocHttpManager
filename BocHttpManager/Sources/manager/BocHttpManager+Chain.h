//
//  BocHttpManager+Chain.h
//  BocHttpManager
//
//  Created by Lixiaopeng on 2019/1/28.
//  Copyright © 2019 bocweb. All rights reserved.
//

#import "BocHttpManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface BocHttpManager (Chain)

- (NSString *)sendChainRequest:(nullable BocChainRequestConfigBlock)configBlock
                      complete:(nullable BocGroupResponseBlock)completeBlock;

- (void)cancelChainRequest:(NSString *)taskID;

@end

NS_ASSUME_NONNULL_END
