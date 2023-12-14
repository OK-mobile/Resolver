//
//  TestZeroParametersSpec.swift
//  Resolver_Tests
//
//  Created by Dmitry Rybochkin on 17/04/2019.
//  Copyright © 2019 OK.RU. All rights reserved.
//

import Quick
import Nimble
import ResolverProtocol

@testable import Resolver_Example

final class TestZeroParametersSpec: QuickSpec, CheckZeroParametersProtocol {

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
    }
}

private extension TestZeroParametersSpec {

    // MARK: - Private functions

    func checkDefaultScope() {
        describe("these will success default scope") {
            checkResolveNew(ParentProtocol.self, ParentClass.self, closure: { resolver in
                resolver.register(ParentProtocol.self, factory: { _ in ParentClass() })
            })
            checkResolveSigletone(ParentProtocol.self, ParentClass.self, scope: nil, closure: { resolver in
                resolver.register(ParentProtocol.self, factory: { _ in ParentClass() })
            })
            checkResolveOptional(ParentProtocol.self, ParentClass.self, scope: nil, closure: { resolver in
                resolver.register(ParentProtocol.self, factory: { _ in ParentClass() })
            })
            checkObjcResolveNew(closure: { resolver in
                resolver.register(ParentProtocol.self, factory: { _ in ParentClass() })
                resolver.register(TestSimpleObjcClassProtocol.self, factory: { _ in TestSimpleObjcClass() })
                resolver.register(TestObjcClassProtocol.self, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: true)
                })
            })
            checkObjcResolveSigletone(scope: nil, closure: { resolver in
                resolver.register(ParentProtocol.self, factory: { _ in ParentClass() })
                resolver.register(TestSimpleObjcClassProtocol.self, factory: { _ in TestSimpleObjcClass() })
                resolver.register(TestObjcClassProtocol.self, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: false)
                })
            })
            checkObjcResolveOptional(scope: nil, closure: { resolver in
                resolver.register(ParentProtocol.self, factory: { _ in ParentClass() })
                resolver.register(TestSimpleObjcClassProtocol.self, factory: { _ in TestSimpleObjcClass() })
                resolver.register(TestObjcClassProtocol.self, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: false)
                })
            })
        }
    }

    func check(scope: ResolverScopeProtocol) {
        describe("these will success single scope \(scope.referenceType)") {
            checkResolveNew(ParentProtocol.self, ParentClass.self, closure: { resolver in
                resolver.register(ParentProtocol.self, scope: scope, factory: { _ in ParentClass() })
            })
            checkResolveSigletone(ParentProtocol.self, ParentClass.self, scope: scope, closure: { resolver in
                resolver.register(ParentProtocol.self, scope: scope, factory: { _ in ParentClass() })
            })
            checkResolveOptional(ParentProtocol.self, ParentClass.self, scope: scope, closure: { resolver in
                resolver.register(ParentProtocol.self, scope: scope, factory: { _ in ParentClass() })
            })
            checkObjcResolveNew(closure: { resolver in
                resolver.register(ParentProtocol.self, scope: scope, factory: { _ in ParentClass() })
                resolver.register(TestSimpleObjcClassProtocol.self, scope: scope, factory: { _ in
                    TestSimpleObjcClass()
                })
                resolver.register(TestObjcClassProtocol.self, scope: scope, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: true)
                })
            })
            checkObjcResolveSigletone(scope: scope, closure: { resolver in
                resolver.register(ParentProtocol.self, scope: scope, factory: { _ in ParentClass() })
                resolver.register(TestSimpleObjcClassProtocol.self, scope: scope, factory: { _ in
                    TestSimpleObjcClass()
                })
                resolver.register(TestObjcClassProtocol.self, scope: scope, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: false)
                })
            })
            checkObjcResolveOptional(scope: scope, closure: { resolver in
                resolver.register(ParentProtocol.self, scope: scope, factory: { _ in ParentClass() })
                resolver.register(TestSimpleObjcClassProtocol.self, scope: scope, factory: { _ in
                    TestSimpleObjcClass()
                })
                resolver.register(TestObjcClassProtocol.self, scope: scope, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: false)
                })
            })
        }
    }
}
