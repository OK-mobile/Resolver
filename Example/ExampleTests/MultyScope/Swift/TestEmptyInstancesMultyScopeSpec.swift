//
//  TestEmptyInstancesMultyScopeSpec.swift
//  Resolver_Tests
//
//  Created by dmitry.rybochkin on 13.05.2020.
//  Copyright © 2020 OK.RU. All rights reserved.
//

import Quick
import Nimble
import ResolverProtocol

final class TestEmptyInstancesMultyScopeSpec: QuickSpec, CheckEmptyInstancesProtocol {

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

private extension TestEmptyInstancesMultyScopeSpec {

    // MARK: - Private functions

    func checkMultyScope(scope1: ResolverScopeProtocol, scope2: ResolverScopeProtocol) {
        describe("these will success multy scope \(scope1.referenceType)/\(scope2.referenceType)") {
            checkEmptyInstances(scopes: [scope1, scope2], useNamespace: true, closure: { resolver in
                resolver.register(ChildProtocol.self, scope: scope1, factory: { _ in ChildClass() })
                resolver.register(ParentProtocol.self, scope: scope2, factory: { _ in ParentClass() })
            })
            checkEmptyInstancesByTypes(scopes: [scope1, scope2], closure: { resolver in
                resolver.register(ChildProtocol.self, scope: scope1, factory: { _ in ChildClass() })
                resolver.register(ParentProtocol.self, scope: scope2, factory: { _ in ParentClass() })
            })
            checkEmptyInstances(scopes: [scope1, scope2], useNamespace: false, closure: { resolver in
                resolver.register(ChildProtocol.self, scope: scope1, factory: { _ in ChildClass() })
                resolver.register(ParentProtocol.self, scope: scope2, factory: { _ in ParentClass() })
            })
            checkEmptyInstancesWithCompletionByTypes(scopes: [scope1, scope2], closure: { resolver in
                resolver.register(ChildProtocol.self, scope: scope1, factory: { _ in ChildClass() })
                resolver.register(ParentProtocol.self, scope: scope2, factory: { _ in ParentClass() })
            })
        }
    }
}
