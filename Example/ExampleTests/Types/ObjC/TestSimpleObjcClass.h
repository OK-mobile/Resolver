//
//  TestSimpleObjcClass.h
//  Resolver_Tests
//
//  Created by dmitry.rybochkin on 12.05.2020.
//  Copyright © 2020 OK.RU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestSimpleObjcClassProtocol.h"
@import ResolverProtocol;

NS_ASSUME_NONNULL_BEGIN

@interface TestSimpleObjcClass : NSObject<TestSimpleObjcClassProtocol>

@end

NS_ASSUME_NONNULL_END
