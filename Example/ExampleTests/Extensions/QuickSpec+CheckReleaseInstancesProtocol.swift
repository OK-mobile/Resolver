//
//  QuickSpec+CheckReleaseInstancesProtocol.swift
//  Resolver_Tests
//
//  Created by dmitry.rybochkin on 13.05.2020.
//  Copyright © 2020 OK.RU. All rights reserved.
//

import Quick
import Nimble
import Resolver
import ResolverProtocol

extension CheckEmptyInstancesProtocol where Self: QuickSpec {
    
    // MARK: - Private functions

    private func register(closure: RegisterClosure?) -> ResolverType {
        let resolver = Resolver(maxRecursiveDepth: 10)
        closure?(resolver)
        return resolver
    }

    private func checkIfScopesEmpty(resolver: SwiftResolverProtocol) {
        weak var weakParent: ParentProtocol? = resolver.resolve()
        weak var weakChild: ChildProtocol? = resolver.resolve()

        expect(weakParent).toNot(beNil())
        expect(weakChild).toNot(beNil())
        resolver.releaseInstance(ParentProtocol.self)
        resolver.releaseInstance(ChildProtocol.self)
        expect(weakParent).to(beNil())
        expect(weakChild).to(beNil())
    }

    private func checkBeforeIfScopesEmpty(resolver: SwiftResolverProtocol) {
        weak var weakParent: ParentProtocol? = resolver.resolve()
        weak var weakChild: ChildProtocol? = resolver.resolve()

        expect(weakParent).toNot(beNil())
        expect(weakChild).toNot(beNil())
        var completionChild = false
        var completionParent = false
        resolver.releaseInstance(ParentProtocol.self, before: { parent in
            completionParent = parent != nil
        })
        resolver.releaseInstance(ChildProtocol.self, before: { child in
            completionChild = child != nil
        })
        expect(completionChild) == true
        expect(completionParent) == true
        expect(weakParent).to(beNil())
        expect(weakChild).to(beNil())
    }

    // MARK: - Functions

    func checkEmptyInstancesByTypes(scopes: [ResolverScopeProtocol], closure: RegisterClosure?) {
        it("test empty instances by types") {
            let resolver = self.register(closure: closure)

            var parent: ParentProtocol? = resolver.resolve()
            expect(parent).toNot(beNil())
            var child: ChildProtocol? = resolver.resolve()
            expect(child).toNot(beNil())
            parent = nil
            child = nil

            if scopes.count < 2 {
                self.checkIfScopesEmpty(resolver: resolver)
                return
            }

            var referenceType = scopes[0].referenceType
            weak var weakChild: ChildProtocol? = resolver.resolve()
            switch referenceType {
            case .strong:
                expect(weakChild).toNot(beNil())
            case .weak, .none:
                break
            }
            
            resolver.releaseInstance(ChildProtocol.self)
            expect(weakChild).to(beNil())

            referenceType = scopes[1].referenceType
            weak var weakParent: ParentProtocol? = resolver.resolve()
            switch referenceType {
            case .strong:
                expect(weakParent).toNot(beNil())
            case .weak, .none:
                break
            }
            
            resolver.releaseInstance(ParentProtocol.self)
            expect(weakParent).to(beNil())
        }
    }

    func checkEmptyInstancesWithCompletionByTypes(scopes: [ResolverScopeProtocol], closure: RegisterClosure?) {
        it("test empty instances by types") {
            let resolver = self.register(closure: closure)

            var parent: ParentProtocol? = resolver.resolve()
            expect(parent).toNot(beNil())
            var child: ChildProtocol? = resolver.resolve()
            expect(child).toNot(beNil())
            parent = nil
            child = nil

            if scopes.count < 2 {
                self.checkBeforeIfScopesEmpty(resolver: resolver)
                return
            }

            var referenceType = scopes[0].referenceType
            weak var weakChild: ChildProtocol? = resolver.resolve()
            switch referenceType {
            case .strong:
                expect(weakChild).toNot(beNil())
            case .weak, .none:
                break
            }
            var completionChild = false
            resolver.releaseInstance(ChildProtocol.self, before: { child in
                completionChild = child != nil || referenceType != .strong
            })
            expect(completionChild) == true
            expect(weakChild).to(beNil())

            referenceType = scopes[1].referenceType
            weak var weakParent: ParentProtocol? = resolver.resolve()
            switch referenceType {
            case .strong:
                expect(weakParent).toNot(beNil())
            case .weak, .none:
                break
            }
            var completionParent = false
            resolver.releaseInstance(ParentProtocol.self, before: { parent in
                completionParent = parent != nil || referenceType != .strong
            })
            expect(completionParent) == true
            expect(weakParent).to(beNil())
        }
    }

    func checkEmptyInstances(scopes: [ResolverScopeProtocol], useNamespace: Bool, closure: RegisterClosure?) {
        it("test empty instances by scopes") {
            let resolver = self.register(closure: closure)

            var parent: ParentProtocol? = resolver.resolve()
            expect(parent).toNot(beNil())
            var child: ChildProtocol? = resolver.resolve()
            expect(child).toNot(beNil())
            parent = nil
            child = nil

            if scopes.count < 2 {
                self.checkIfScopesEmpty(resolver: resolver)
                self.checkBeforeIfScopesEmpty(resolver: resolver)
                return
            }

            weak var weakChild: ChildProtocol? = resolver.resolve()
            switch scopes[0].referenceType {
            case .strong:
                expect(weakChild).toNot(beNil())
            case .weak, .none:
                break
            }
            if useNamespace {
                resolver.releaseInstances(namespace: scopes[0].namespace)
            } else {
                resolver.releaseInstances(scope: scopes[0])
            }
            expect(weakChild).to(beNil())

            weak var weakParent: ParentProtocol? = resolver.resolve()
            switch scopes[1].referenceType {
            case .strong:
                expect(weakParent).toNot(beNil())
            case .weak, .none:
                break
            }
            if useNamespace {
                resolver.releaseInstances(namespace: scopes[1].namespace)
            } else {
                resolver.releaseInstances(scope: scopes[1])
            }
            expect(weakParent).to(beNil())
        }
    }
}
