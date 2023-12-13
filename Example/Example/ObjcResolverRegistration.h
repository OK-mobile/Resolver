//
//  ObjcResolverRegistration.h
//  Example
//
//  Created by dmitry.rybochkin on 01.02.2021.
//  Copyright © 2020 OK.RU. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ResolverProtocol;

@interface ObjcResolverRegistration : NSObject

- (instancetype)initWithResolver:(id<ResolverProtocol>)resolver;

@end

NS_ASSUME_NONNULL_END
