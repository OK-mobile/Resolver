//
//  TestParentChildMultyScopeSpec.swift
//  Resolver_Tests
//
//  Created by dmitry.rybochkin on 13.05.2020.
//  Copyright © 2020 OK.RU. All rights reserved.
//

import Quick
import Nimble
import ResolverProtocol

final class TestParentChildMultyScopeSpec: QuickSpec, CheckParentChildProtocol {

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

private extension TestParentChildMultyScopeSpec {

    // MARK: - Private functions

    func checkMultyScope(scope1: ResolverScopeProtocol, scope2: ResolverScopeProtocol) {
        describe("these will success multy scope \(scope1.referenceType)/\(scope2.referenceType)") {
            checkParentWithChild(closure: { resolver in
                resolver.register(ChildProtocol.self, scope: scope1, factory: { _ in ChildClass() })
                resolver.register(ParentProtocol.self, scope: scope2, factory: {
                    ParentClass(property1: $0.resolve())
                })
            })
            checkOptionalStrong(closure: { resolver in
                resolver.register(ChildProtocol.self, scope: scope1, factory: { resolver in
                    ChildClass(parent: resolver.resolve())
                })
                resolver.register(ParentProtocol.self, scope: scope2, factory: { _ in nil })
            })
        }
    }
}
