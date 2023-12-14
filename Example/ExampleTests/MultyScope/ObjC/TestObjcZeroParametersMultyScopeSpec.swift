//
//  TestObjcZeroParametersMultyScopeSpec.swift
//  Resolver_Tests
//
//  Created by dmitry.rybochkin on 13.05.2020.
//  Copyright © 2020 OK.RU. All rights reserved.
//

import Quick
import Nimble
import ResolverProtocol

@testable import Resolver_Example

final class TestObjcZeroParametersMultyScopeSpec: QuickSpec, CheckZeroParametersProtocol {

    // MARK: - Private properties

    private let scopes: [ResolverScopeProtocol] = [
        ResolverScope(referenceType: .strong, namespace: "multyScopeStrong"),
        ResolverScope(referenceType: .weak, namespace: "multyScopeWeak"),
        ResolverScope(referenceType: .none, namespace: "multyScopeNone")
    ]

    // MARK: - Lifecycle

    override func spec() {
        scopes.forEach({ scope1 in
            scopes.forEach({ scope2 in
                checkMultyScope(scope1: scope1, scope2: scope2)
                checkMultyScopeObjc(scope1: scope1, scope2: scope2)
            })
        })
    }
}

private extension TestObjcZeroParametersMultyScopeSpec {

    // MARK: - Private functions

    func checkMultyScope(scope1: ResolverScopeProtocol, scope2: ResolverScopeProtocol) {
        describe("these will success multy scope \(scope1.referenceType)/\(scope2.referenceType)") {
            checkResolveNew(ParentProtocol.self, ParentClass.self, closure: { resolver in
                resolver.register(ParentProtocol.self, scope: scope1, factory: { _ in ParentClass() })
            })
            checkResolveSigletone(ParentProtocol.self, ParentClass.self, scope: scope1, closure: { resolver in
                resolver.register(ParentProtocol.self, scope: scope1, factory: { _ in ParentClass() })
            })
            checkResolveOptional(ParentProtocol.self, ParentClass.self, scope: scope1, closure: { resolver in
                resolver.register(ParentProtocol.self, scope: scope1, factory: { _ in ParentClass() })
            })
            checkObjcResolveNew(closure: { resolver in
                resolver.register(TestSimpleObjcClassProtocol.self, scope: scope1, factory: { _ in
                    TestSimpleObjcClass()
                })
                resolver.register(TestObjcClassProtocol.self, scope: scope2, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: true)
                })
            })
            checkObjcResolveSigletone(scope: scope1, closure: { resolver in
                resolver.register(TestSimpleObjcClassProtocol.self, scope: scope1, factory: { _ in
                    TestSimpleObjcClass()
                })
                resolver.register(TestObjcClassProtocol.self, scope: scope2, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: false)
                })
            })
            checkObjcResolveOptional(scope: scope1, closure: { resolver in
                resolver.register(TestSimpleObjcClassProtocol.self, scope: scope1, factory: { _ in
                    TestSimpleObjcClass()
                })
                resolver.register(TestObjcClassProtocol.self, scope: scope2, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: false)
                })
            })
        }
    }
    
    func checkMultyScopeObjc(scope1: ResolverScopeProtocol, scope2: ResolverScopeProtocol) {
        describe("these will success multy scope \(scope1.referenceType)/\(scope2.referenceType) objc") {
            checkObjcResolveNewAsObjcProtocol(closure: { resolver in
                resolver.register(protocol: TestSimpleObjcClassProtocol.self, scope: scope1, factory: { _ in
                    TestSimpleObjcClass()
                })
                resolver.register(protocol: TestObjcClassProtocol.self, scope: scope2, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: true)
                })
            })
            checkObjcResolveNewAsObjcClass(closure: { resolver in
                resolver.register(protocol: TestSimpleObjcClassProtocol.self, scope: scope1, factory: { _ in
                    TestSimpleObjcClass()
                })
                resolver.register(protocol: TestObjcClassProtocol.self, scope: scope2, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: true)
                })
                resolver.register(class: TestSimpleObjcClass.self, scope: scope1, factory: { _ in
                    TestSimpleObjcClass()
                })
                resolver.register(class: TestObjcClass.self, scope: scope2, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: true)
                })
            })
            checkObjcResolveSigletoneAsObjcProtocol(scope1: scope1, scope2: scope2, closure: { resolver in
                resolver.register(protocol: TestSimpleObjcClassProtocol.self, scope: scope1, factory: { _ in
                    TestSimpleObjcClass()
                })
                resolver.register(protocol: TestObjcClassProtocol.self, scope: scope2, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: false)
                })
            })
            checkObjcResolveSigletoneAsObjClass(scope1: scope1, scope2: scope2, closure: { resolver in
                resolver.register(protocol: TestSimpleObjcClassProtocol.self, scope: scope1, factory: { _ in
                    TestSimpleObjcClass()
                })
                resolver.register(protocol: TestObjcClassProtocol.self, scope: scope2, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: false)
                })
                resolver.register(class: TestSimpleObjcClass.self, scope: scope1, factory: { _ in
                    TestSimpleObjcClass()
                })
                resolver.register(class: TestObjcClass.self, scope: scope2, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: false)
                })
            })
        }
    }
}
