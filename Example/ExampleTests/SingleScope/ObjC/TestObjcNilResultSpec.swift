//
//  TestObjcNilResultSpec.swift
//  ExampleTests
//
//  Created by dmitry.rybochkin on 12.03.2021.
//  Copyright © 2021 OK.RU. All rights reserved.
//

import Quick
import Nimble
import Resolver
import ResolverProtocol

@testable import Resolver_Example

final class TestObjcNilResultSpec: QuickSpec, CheckNilResultProtocol {

    // MARK: - Private properties

    private let scopes: [ResolverScopeProtocol] = [
        ResolverScope(referenceType: .strong, namespace: "singleScopeStrong"),
        ResolverScope(referenceType: .weak, namespace: "singleScopeWeak"),
        ResolverScope(referenceType: .none, namespace: "singleScopeNone")
    ]

    // MARK: - Lifecycle

    override func spec() {
        checkDefaultScope()

        scopes.forEach({ check(scope: $0) })
        scopes.forEach({ checkObjc(scope: $0) })
    }
}

private extension TestObjcNilResultSpec {

    // MARK: - Private functions

    func checkDefaultScope() {
        describe("these will success default scope nil result") {
            checkResolveNew(TestObjcClassProtocol.self, TestObjcClass.self, closure: { resolver in
                resolver.register(TestObjcClassProtocol.self, factory: { _ in TestObjcClass() })
                resolver.register(TestSimpleObjcClassProtocol.self, factory: { _ in nil })
            })
            checkResolveSigletone(TestObjcClassProtocol.self, TestObjcClass.self, scope: nil, closure: { resolver in
                resolver.register(TestObjcClassProtocol.self, factory: { _ in TestObjcClass() })
                resolver.register(TestSimpleObjcClassProtocol.self, factory: { _ in nil })
            })
            checkResolveOptional(TestObjcClassProtocol.self, TestObjcClass.self, scope: nil, closure: { resolver in
                resolver.register(TestObjcClassProtocol.self, factory: { _ in TestObjcClass() })
                resolver.register(TestSimpleObjcClassProtocol.self, factory: { _ in nil })
            })
            checkObjcResolveNew(closure: { resolver in
                resolver.register(TestObjcClassProtocol.self, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: true)
                })
                resolver.register(TestSimpleObjcClassProtocol.self, factory: { _ in nil })
            })
            checkObjcResolveSigletone(scope: nil, closure: { resolver in
                resolver.register(TestObjcClassProtocol.self, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: false)
                })
                resolver.register(TestSimpleObjcClassProtocol.self, factory: { _ in nil })
            })
            checkObjcResolveOptional(scope: nil, closure: { resolver in
                resolver.register(TestObjcClassProtocol.self, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: false)
                })
                resolver.register(TestSimpleObjcClassProtocol.self, factory: { _ in nil })
            })
        }
    }

    func check(scope: ResolverScopeProtocol) {
        describe("these will success single scope \(scope.referenceType) nil result") {
            checkResolveNew(TestObjcClassProtocol.self, TestObjcClass.self, closure: { resolver in
                resolver.register(TestObjcClassProtocol.self, scope: scope, factory: { _ in TestObjcClass() })
                resolver.register(TestSimpleObjcClassProtocol.self, factory: { _ in nil })
            })
            checkResolveSigletone(TestObjcClassProtocol.self, TestObjcClass.self, scope: scope, closure: { resolver in
                resolver.register(TestObjcClassProtocol.self, scope: scope, factory: { _ in TestObjcClass() })
                resolver.register(TestSimpleObjcClassProtocol.self, factory: { _ in nil })
            })
            checkResolveOptional(TestObjcClassProtocol.self, TestObjcClass.self, scope: scope, closure: { resolver in
                resolver.register(TestObjcClassProtocol.self, scope: scope, factory: { _ in TestObjcClass() })
                resolver.register(TestSimpleObjcClassProtocol.self, factory: { _ in nil })
            })
            checkObjcResolveNew(closure: { resolver in
                resolver.register(TestObjcClassProtocol.self, scope: scope, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: true)
                })
                resolver.register(TestSimpleObjcClassProtocol.self, factory: { _ in nil })
            })
            checkObjcResolveSigletone(scope: scope, closure: { resolver in
                resolver.register(TestObjcClassProtocol.self, scope: scope, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: false)
                })
                resolver.register(TestSimpleObjcClassProtocol.self, factory: { _ in nil })
            })
            checkObjcResolveOptional(scope: scope, closure: { resolver in
                resolver.register(TestObjcClassProtocol.self, scope: scope, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: false)
                })
                resolver.register(TestSimpleObjcClassProtocol.self, factory: { _ in nil })
            })
        }
    }
    
    func checkObjc(scope: ResolverScopeProtocol) {
        describe("these will success single scope \(scope.referenceType) for objc nil result") {
            checkObjcResolveNewAsObjcProtocol(closure: { resolver in
                resolver.register(protocol: TestObjcClassProtocol.self, scope: scope, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: true)
                })
                resolver.register(TestSimpleObjcClassProtocol.self, factory: { _ in nil })
            })
            
            checkObjcResolveNewAsObjcClass(closure: { resolver in
                resolver.register(TestSimpleObjcClassProtocol.self, factory: { _ in nil })
                resolver.register(TestObjcClassProtocol.self, scope: scope, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: true)
                })
                resolver.register(TestSimpleObjcClass.self, factory: { _ in nil })
                resolver.register(class: TestObjcClass.self, scope: scope, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: true)
                })
            })
            
            checkObjcResolveSigletoneAsObjcProtocol(scope1: scope, scope2: scope, closure: { resolver in
                resolver.register(protocol: TestSimpleObjcClassProtocol.self, scope: scope, factory: { _ in nil })
                resolver.register(protocol: TestObjcClassProtocol.self, scope: scope, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: false)
                })
            })
            
            checkObjcResolveSigletoneAsObjClass(scope1: scope, scope2: scope, closure: { resolver in
                resolver.register(TestSimpleObjcClassProtocol.self, scope: scope, factory: { _ in nil })
                resolver.register(TestObjcClassProtocol.self, scope: scope, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: true)
                })
                resolver.register(class: TestSimpleObjcClass.self, scope: scope, factory: { _ in nil })
                resolver.register(class: TestObjcClass.self, scope: scope, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: true)
                })
            })
        }
    }
}
