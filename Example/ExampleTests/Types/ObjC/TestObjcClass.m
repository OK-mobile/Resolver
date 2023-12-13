//
//  TestObjcClass.m
//  Resolver_Example
//
//  Created by Dmitriy Rybochkin on 15.02.2020.
//  Copyright © 2020 OK.RU. All rights reserved.
//

#import "TestObjcClass.h"
#import "TestSimpleObjcClassProtocol.h"

@implementation TestObjcClass

@synthesize childObject;
@synthesize numberValue;

- (instancetype)initWithResolver:(id<ResolverProtocol>)resolver asNew:(BOOL)asNew {
    self = [super init];
    if (self) {
        if (asNew) {
            self.childObject = [resolver resolveNewWithProtocol:@protocol(TestSimpleObjcClassProtocol)];
        } else {
            self.childObject = [resolver resolveWithProtocol:@protocol(TestSimpleObjcClassProtocol)];
        }
    }
    return self;
}

@end
