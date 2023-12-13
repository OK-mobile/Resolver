//
//  TestZeroParametersMultyScopeSpec.swift
//  Resolver_Tests
//
//  Created by dmitry.rybochkin on 13.05.2020.
//  Copyright © 2020 OK.RU. All rights reserved.
//

import Quick
import Nimble
import ResolverProtocol

final class TestZeroParametersMultyScopeSpec: QuickSpec, CheckZeroParametersProtocol {

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
            })
        })
    }
}

private extension TestZeroParametersMultyScopeSpec {

    // MARK: - Private functions

    func checkMultyScope(scope1: ResolverScopeProtocol, scope2: ResolverScopeProtocol) {
        describe("these will success multy scope strong/none") {
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
                resolver.register(ParentProtocol.self, scope: scope1, factory: { _ in ParentClass() })
                resolver.register(TestSimpleObjcClassProtocol.self, scope: scope1, factory: { _ in
                    TestSimpleObjcClass()
                })
                resolver.register(TestObjcClassProtocol.self, scope: scope2, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: true)
                })
            })
            checkObjcResolveSigletone(scope: scope1, closure: { resolver in
                resolver.register(ParentProtocol.self, scope: scope1, factory: { _ in ParentClass() })
                resolver.register(TestSimpleObjcClassProtocol.self, scope: scope1, factory: { _
                    in TestSimpleObjcClass()
                })
                resolver.register(TestObjcClassProtocol.self, scope: scope2, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: false)
                })
            })
            checkObjcResolveOptional(scope: scope1, closure: { resolver in
                resolver.register(ParentProtocol.self, scope: scope1, factory: { _ in ParentClass() })
                resolver.register(TestSimpleObjcClassProtocol.self, scope: scope1, factory: { _
                    in TestSimpleObjcClass()
                })
                resolver.register(TestObjcClassProtocol.self, scope: scope2, factory: { resolver in
                    TestObjcClass(resolver: resolver, asNew: false)
                })
            })
        }
    }
}
