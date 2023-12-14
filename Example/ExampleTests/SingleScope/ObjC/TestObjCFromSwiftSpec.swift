//
//  TestObjCFromSwiftSpec.swift
//  Resolver_Tests
//
//  Created by dmitry.rybochkin on 12.05.2020.
//  Copyright © 2020 OK.RU. All rights reserved.
//

import Quick
import Nimble
import ResolverProtocol

@testable import Resolver_Example

final class TestObjCFromSwiftSpec: QuickSpec, CheckZeroParametersProtocol {

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

private extension TestObjCFromSwiftSpec {

    // MARK: - Private functions

    func checkDefaultScope() {
        describe("these will success default scope") {
            checkResolveNew(TestObjcClassProtocol.self, TestObjcClass.self, closure: { resolver in
                resolver.register(TestObjcClassProtocol.self, factory: { _ in TestObjcClass() })
            })
            checkResolveSigletone(TestObjcClassProtocol.self, TestObjcClass.self, scope: nil, closure: { resolver in
                resolver.register(TestObjcClassProtocol.self, factory: { _ in TestObjcClass() })
            })
            checkResolveOptional(TestObjcClassProtocol.self, TestObjcClass.self, scope: nil, closure: { resolver in
                resolver.register(TestObjcClassProtocol.self, factory: { _ in TestObjcClass() })
            })
            checkObjcResolveNew(closure: { resolver in
                resolver.register(TestSimpleObjcClassProtocol.self, factory: { _ in TestSimpleObjcClass() })
                resolver.register(TestObjcClassProtocol.self, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: true)
                })
            })
            checkObjcResolveSigletone(scope: nil, closure: { resolver in
                resolver.register(TestSimpleObjcClassProtocol.self, factory: { _ in TestSimpleObjcClass() })
                resolver.register(TestObjcClassProtocol.self, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: false)
                })
            })
            checkObjcResolveOptional(scope: nil, closure: { resolver in
                resolver.register(TestSimpleObjcClassProtocol.self, factory: { _ in TestSimpleObjcClass() })
                resolver.register(TestObjcClassProtocol.self, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: false)
                })
            })
        }
    }

    func check(scope: ResolverScopeProtocol) {
        describe("these will success single scope \(scope.referenceType)") {
            checkResolveNew(TestObjcClassProtocol.self, TestObjcClass.self, closure: { resolver in
                resolver.register(TestObjcClassProtocol.self, scope: scope, factory: { _ in TestObjcClass() })
            })
            checkResolveSigletone(TestObjcClassProtocol.self, TestObjcClass.self, scope: scope, closure: { resolver in
                resolver.register(TestObjcClassProtocol.self, scope: scope, factory: { _ in TestObjcClass() })
            })
            checkResolveOptional(TestObjcClassProtocol.self, TestObjcClass.self, scope: scope, closure: { resolver in
                resolver.register(TestObjcClassProtocol.self, scope: scope, factory: { _ in TestObjcClass() })
            })
            checkObjcResolveNew(closure: { resolver in
                resolver.register(TestSimpleObjcClassProtocol.self, scope: scope, factory: { _ in
                    TestSimpleObjcClass()
                })
                resolver.register(TestObjcClassProtocol.self, scope: scope, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: true)
                })
            })
            checkObjcResolveSigletone(scope: scope, closure: { resolver in
                resolver.register(TestSimpleObjcClassProtocol.self, scope: scope, factory: { _ in
                    TestSimpleObjcClass()
                })
                resolver.register(TestObjcClassProtocol.self, scope: scope, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: false)
                })
            })
            checkObjcResolveOptional(scope: scope, closure: { resolver in
                resolver.register(TestSimpleObjcClassProtocol.self, scope: scope, factory: { _ in
                    TestSimpleObjcClass()
                })
                resolver.register(TestObjcClassProtocol.self, scope: scope, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: false)
                })
            })
        }
    }
    
    func checkObjc(scope: ResolverScopeProtocol) {
        describe("these will success single scope \(scope.referenceType) for objc") {
            checkObjcResolveNewAsObjcProtocol(closure: { resolver in
                resolver.register(protocol: TestSimpleObjcClassProtocol.self, scope: scope, factory: { _ in
                    TestSimpleObjcClass()
                })
                resolver.register(protocol: TestObjcClassProtocol.self, scope: scope, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: true)
                })
            })
            
            checkObjcResolveNewAsObjcClass(closure: { resolver in
                resolver.register(TestSimpleObjcClassProtocol.self, scope: scope, factory: { _ in
                    TestSimpleObjcClass()
                })
                resolver.register(TestObjcClassProtocol.self, scope: scope, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: true)
                })
                resolver.register(class: TestSimpleObjcClass.self, scope: scope, factory: { _ in
                    TestSimpleObjcClass()
                })
                resolver.register(class: TestObjcClass.self, scope: scope, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: true)
                })
            })
            
            checkObjcResolveSigletoneAsObjcProtocol(scope1: scope, scope2: scope, closure: { resolver in
                resolver.register(protocol: TestSimpleObjcClassProtocol.self, scope: scope, factory: { _ in
                    TestSimpleObjcClass()
                })
                resolver.register(protocol: TestObjcClassProtocol.self, scope: scope, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: false)
                })
            })
            
            checkObjcResolveSigletoneAsObjClass(scope1: scope, scope2: scope, closure: { resolver in
                resolver.register(TestSimpleObjcClassProtocol.self, scope: scope, factory: { _ in
                    TestSimpleObjcClass()
                })
                resolver.register(TestObjcClassProtocol.self, scope: scope, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: true)
                })
                resolver.register(class: TestSimpleObjcClass.self, scope: scope, factory: { _ in
                    TestSimpleObjcClass()
                })
                resolver.register(class: TestObjcClass.self, scope: scope, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: true)
                })
            })
        }
    }
}
