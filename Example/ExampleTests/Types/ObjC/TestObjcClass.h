//
//  TestObjcClass.h
//  Resolver_Example
//
//  Created by Dmitriy Rybochkin on 15.02.2020.
//  Copyright © 2020 OK.RU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestObjcClassProtocol.h"
@import ResolverProtocol;

NS_ASSUME_NONNULL_BEGIN

@interface TestObjcClass : NSObject<TestObjcClassProtocol>

- (instancetype)initWithResolver:(id<ResolverProtocol>)resolver asNew:(BOOL)asNew;

@end

NS_ASSUME_NONNULL_END
