//
//  TestParentChildSpec.swift
//  Resolver_Tests
//
//  Created by Dmitry Rybochkin on 23/04/2019.
//  Copyright © 2019 OK.RU. All rights reserved.
//

import Quick
import Nimble
import ResolverProtocol

final class TestParentChildSpec: QuickSpec, CheckParentChildProtocol {

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

private extension TestParentChildSpec {

    // MARK: - Private functions

    func checkDefaultScope() {
        describe("these will success default scope") {
            checkParentWithChild(closure: { resolver in
                resolver.register(ChildProtocol.self, factory: { _ in ChildClass() })
                resolver.register(ParentProtocol.self, factory: {
                    ParentClass(property1: $0.resolve())
                })
            })
            checkOptionalStrong(closure: { resolver in
                resolver.register(ChildProtocol.self, factory: { resolver in ChildClass(parent: resolver.resolve()) })
                resolver.register(ParentProtocol.self, factory: { _ in nil })
            })
        }
    }

    func check(scope: ResolverScopeProtocol) {
        describe("these will success single scope \(scope.referenceType)") {
            checkParentWithChild(closure: { resolver in
                resolver.register(ChildProtocol.self, scope: scope, factory: { _ in ChildClass() })
                resolver.register(ParentProtocol.self, scope: scope, factory: {
                    ParentClass(property1: $0.resolve())
                })
            })
            checkOptionalStrong(closure: { resolver in
                resolver.register(ChildProtocol.self, scope: scope, factory: { resolver in
                    ChildClass(parent: resolver.resolve())
                })
                resolver.register(ParentProtocol.self, scope: scope, factory: { _ in nil })
            })
        }
    }
}
