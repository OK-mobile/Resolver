//
//  TestEmptyInstancesSpec.swift
//  Resolver_Tests
//
//  Created by dmitry.rybochkin on 13.05.2020.
//  Copyright © 2020 OK.RU. All rights reserved.
//

import Quick
import Nimble
import ResolverProtocol

final class TestEmptyInstancesSpec: QuickSpec, CheckEmptyInstancesProtocol {

    // MARK: - Private properties

    private let scopes: [ResolverScopeProtocol] = [
        ResolverScope(referenceType: .strong, namespace: "singleScopeStrong"),
        ResolverScope(referenceType: .weak, namespace: "singleScopeWeak"),
        ResolverScope(referenceType: .none, namespace: "singleScopeNone")
    ]

    // MARK: - Lifecycle

    override func spec() {
        checkDefaultScope()

        scopes.forEach({ scope in
            check(scope: scope)
        })
    }
}

private extension TestEmptyInstancesSpec {

    // MARK: - Private functions

    func checkDefaultScope() {
        describe("these will success default scope") {
            checkEmptyInstances(scopes: [], useNamespace: true, closure: { resolver in
                resolver.register(ChildProtocol.self, factory: { _ in ChildClass() })
                resolver.register(ParentProtocol.self, factory: { _ in ParentClass() })
            })
            checkEmptyInstancesByTypes(scopes: [], closure: { resolver in
                resolver.register(ChildProtocol.self, factory: { _ in ChildClass() })
                resolver.register(ParentProtocol.self, factory: { _ in ParentClass() })
            })
            checkEmptyInstances(scopes: [], useNamespace: false, closure: { resolver in
                resolver.register(ChildProtocol.self, factory: { _ in ChildClass() })
                resolver.register(ParentProtocol.self, factory: { _ in ParentClass() })
            })
            checkEmptyInstancesWithCompletionByTypes(scopes: [], closure: { resolver in
                resolver.register(ChildProtocol.self, factory: { _ in ChildClass() })
                resolver.register(ParentProtocol.self, factory: { _ in ParentClass() })
            })
        }
    }

    func check(scope: ResolverScopeProtocol) {
        describe("these will success single scope \(scope.referenceType)") {
            checkEmptyInstances(scopes: [scope, scope], useNamespace: true, closure: { resolver in
                resolver.register(ChildProtocol.self, scope: scope, factory: { _ in ChildClass() })
                resolver.register(ParentProtocol.self, scope: scope, factory: { _ in ParentClass() })
            })
            checkEmptyInstancesByTypes(scopes: [scope, scope], closure: { resolver in
                resolver.register(ChildProtocol.self, scope: scope, factory: { _ in ChildClass() })
                resolver.register(ParentProtocol.self, scope: scope, factory: { _ in ParentClass() })
            })
            checkEmptyInstances(scopes: [scope, scope], useNamespace: false, closure: { resolver in
                resolver.register(ChildProtocol.self, scope: scope, factory: { _ in ChildClass() })
                resolver.register(ParentProtocol.self, scope: scope, factory: { _ in ParentClass() })
            })
            checkEmptyInstancesWithCompletionByTypes(scopes: [scope, scope], closure: { resolver in
                resolver.register(ChildProtocol.self, scope: scope, factory: { _ in ChildClass() })
                resolver.register(ParentProtocol.self, scope: scope, factory: { _ in ParentClass() })
            })
        }
    }
}
