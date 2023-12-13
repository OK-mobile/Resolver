//
//  TestObjcClassProtocol.h
//  Resolver
//
//  Created by dmitry.rybochkin on 12.05.2020.
//  Copyright © 2020 OK.RU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestSimpleObjcClassProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TestObjcClassProtocol <NSObject>

@property (nonatomic, copy) NSNumber *numberValue;
@property (nonatomic, nullable) id<TestSimpleObjcClassProtocol> childObject;

@end

NS_ASSUME_NONNULL_END
