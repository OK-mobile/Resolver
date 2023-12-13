//
//  ObjcResolverRegistration.m
//  Example
//
//  Created by dmitry.rybochkin on 01.02.2021.
//  Copyright © 2020 OK.RU. All rights reserved.
//

#import "ObjcResolverRegistration.h"
#import "TestObjcClassProtocol.h"
#import "TestObjcClass.h"
#import "TestSimpleObjcClassProtocol.h"
#import "TestSimpleObjcClass.h"

@import Resolver;
@import ResolverProtocol;

@interface ObjcResolverRegistration ()
@property (nonatomic) id<ResolverProtocol> resolver;
@end

@implementation ObjcResolverRegistration

- (instancetype)init {
    self = [super init];
    if (self) {
        _resolver = [Resolver new];
        [self registrating];
        [self resolving];
    }
    return self;
}

- (instancetype)initWithResolver:(id<ResolverProtocol>)resolver {
    self = [super init];
    if (self) {
        _resolver = resolver;
        [self registrating];
        [self subscribing];
        [self resolving];
    }
    return self;
}

- (void)registrating {
    [self.resolver registerWithClass:TestSimpleObjcClass.class factory:^id _Nullable(id<ResolverProtocol> _Nonnull container) {
        return [TestSimpleObjcClass new];
    }];
    [self.resolver registerWithClass:TestObjcClass.class factory:^id _Nullable(id<ResolverProtocol> _Nonnull container) {
        return [[TestObjcClass alloc] initWithResolver:container asNew:NO];
    }];

    [self.resolver registerWithProtocol:@protocol(TestSimpleObjcClassProtocol) factory:^id _Nullable(id<ResolverProtocol> _Nonnull container) {
        return [TestSimpleObjcClass new];
    }];
    [self.resolver registerWithProtocol:@protocol(TestObjcClassProtocol) factory:^id _Nullable(id<ResolverProtocol> _Nonnull container) {
        return [[TestObjcClass alloc] initWithResolver:container asNew:NO];
    }];
}

- (void)subscribing {
    [self.resolver subscribe:self class:TestObjcClass.class event:^(TestObjcClass *testObject) {
        NSLog(@"subscribe %@", testObject);
    }];
    [self.resolver subscribe:self protocol:@protocol(TestSimpleObjcClassProtocol) event:^(id<TestSimpleObjcClassProtocol> testSimpleObj) {
        NSLog(@"subscribe %@", testSimpleObj);
    }];
}

- (void)resolving {
    id<TestSimpleObjcClassProtocol> simplResultObj = [self.resolver resolveWithClass:TestSimpleObjcClass.class];
    NSLog(@"resolve simplResultObj = %@", simplResultObj);
    id<TestObjcClassProtocol> resultObj = [self.resolver resolveWithClass:TestObjcClass.class];
    NSLog(@"resolve resultObj = %@ %@", resultObj, resultObj.childObject);
    id<TestSimpleObjcClassProtocol> simplResult = [self.resolver resolveWithProtocol:@protocol(TestSimpleObjcClassProtocol)];
    NSLog(@"resolve simplResult = %@", simplResult);
    id<TestObjcClassProtocol> result = [self.resolver resolveWithProtocol:@protocol(TestObjcClassProtocol)];
    NSLog(@"resolve result = %@ %@", result, result.childObject);
}

@end
