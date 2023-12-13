//
//  TestUnsafeRegisterMultiScopeSpec.swift
//  ResolverTests
//
//  Created by dmitry.rybochkin on 27.07.2020.
//  Copyright © 2020 OK.RU. All rights reserved.
//

import Quick
import Nimble
import Resolver
import ResolverProtocol

final class TestUnsafeRegisterMultiScopeSpec: QuickSpec {

    // MARK: - Private properties

    private let scopes: [ResolverScopeProtocol] = [
        ResolverScope(referenceType: .strong, namespace: "singleScopeStrong"),
        ResolverScope(referenceType: .weak, namespace: "singleScopeWeak"),
        ResolverScope(referenceType: .none, namespace: "singleScopeNone")
    ]

    // MARK: - Lifecycle

    override func spec() {
        scopes.forEach({ scope1 in
            scopes.forEach({ scope2 in
                checkMulty(scope1: scope1, scope2: scope2)
            })
        })
    }
}

private extension TestUnsafeRegisterMultiScopeSpec {

    // MARK: - Private functions

    func checkMulty(scope1: ResolverScopeProtocol, scope2: ResolverScopeProtocol) {
        let value = Int.random(in: -1000..<1000)
        let uidString = UUID().uuidString
        describe("these will success") {
            it("test multi scopes unsafeRegister unsafeResolve \(scope1.namespace) \(scope2.namespace)") {
                let container = Resolver()
                expect(container).toNot(beNil())
                container.register(closure: { resolver in
                    resolver.register(ChildProtocol.self, scope: scope1, factory: { _ in ChildClass(value: value) })

                    let child = resolver.resolve(ChildProtocol.self)
                    expect(child).toNot(beNil())
                    expect(child?.value) == value

                    resolver.register(ParentProtocol.self, scope: scope2, factory: { _ in
                        ParentClass(property2: value, property3: uidString, property4: child)
                    })
                    let parent = resolver.resolve(ParentProtocol.self)
                    expect(parent).toNot(beNil())
                    expect(parent?.property2) == value
                    expect(parent?.property3) == uidString
                    expect(parent?.property4) === child
                    let parentNew = container.resolveNew(ParentProtocol.self)
                    expect(parent) !== parentNew
                })
                
                let child = container.resolve(ChildProtocol.self)
                expect(child).toNot(beNil())
                expect(child?.value) == value

                let parent = container.resolve(ParentProtocol.self)
                expect(parent).toNot(beNil())
                expect(parent?.property2) == value
                expect(parent?.property3) == uidString
                switch scope1.referenceType {
                case .weak, .strong:
                    expect(parent?.property4) === child
                case .none:
                    expect(parent?.property4) !== child
                }
                let parentNew = container.resolveNew(ParentProtocol.self)
                expect(parent) !== parentNew
            }
        }
    }
}
