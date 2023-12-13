//
//  TestCrossLinkSpec.swift
//  ExampleTests
//
//  Created by dmitry.rybochkin on 15.10.2020.
//  Copyright © 2020 OK.RU. All rights reserved.
//

import Quick
import Nimble
import Resolver
import ResolverProtocol

final class TestCrossLinkSpec: QuickSpec, CheckParentChildProtocol {

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

private extension TestCrossLinkSpec {

    // MARK: - Private functions

    func checkDefaultScope() {
        describe("these will success default scope") {
            checkCrossLink(closure: { resolver in
                resolver.register(ChildProtocol.self, factory: { _ in
                    ChildClass()
                }, completion: { resolver, resolvedObject in
                    resolvedObject?.parent = resolver.resolve()
                })
                resolver.register(ParentProtocol.self, factory: { _ in
                    ParentClass()
                }, completion: { resolver, resolvedObject in
                    resolvedObject?.child = resolver.resolve()
                })
            }, scope: nil)
            checkOptionalStrong(closure: { resolver in
                resolver.register(ChildProtocol.self, factory: { _ in
                    ChildClass()
                }, completion: { resolver, resolvedObject in
                    resolvedObject?.parent = resolver.resolve()
                })
                resolver.register(ParentProtocol.self, factory: { _ in nil })
            })
        }
    }

    func check(scope: ResolverScopeProtocol) {
        describe("these will success single scope \(scope.referenceType)") {
            checkCrossLink(closure: { resolver in
                resolver.register(ChildProtocol.self, scope: scope, factory: { _ in
                    ChildClass()
                }, completion: { resolver, resolvedObject in
                    resolvedObject?.parent = resolver.resolve()
                })
                resolver.register(ParentProtocol.self, scope: scope, factory: { _ in
                    ParentClass()
                }, completion: { resolver, resolvedObject in
                    resolvedObject?.child = resolver.resolve()
                })
            }, scope: scope)
            checkOptionalStrong(closure: { resolver in
                resolver.register(ChildProtocol.self, scope: scope, factory: { _ in
                    ChildClass()
                }, completion: { resolver, resolvedObject in
                    resolvedObject?.parent = resolver.resolve()
                })
                resolver.register(ParentProtocol.self, scope: scope, factory: { _ in nil })
            })
        }
    }

    func register(closure: RegisterClosure?) -> ResolverType {
        let resolver = Resolver(maxRecursiveDepth: 10)
        closure?(resolver)
        return resolver
    }

    func checkCrossLink(closure: RegisterClosure?, scope: ResolverScopeProtocol?) {
        it("test register/resolve parent/child") {
            let resolver = self.register(closure: closure)
            let parent: ParentProtocol? = resolver.resolve()
            expect(parent).toNot(beNil())
            guard let scope = scope, scope.referenceType == .none else {
                expect(parent?.child).toNot(beNil())
                expect(parent?.child?.parent).toNot(beNil())
                return
            }
            expect(parent?.child).to(beNil())
        }
    }
}
