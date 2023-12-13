//
//  QuickSpec+CheckParentChildProtocol.swift
//  Resolver_Tests
//
//  Created by dmitry.rybochkin on 13.05.2020.
//  Copyright © 2020 OK.RU. All rights reserved.
//

import Quick
import Nimble
import Resolver
import ResolverProtocol

extension CheckParentChildProtocol where Self: QuickSpec {

    // MARK: - Private functions

    private func register(closure: RegisterClosure?) -> SwiftResolverProtocol {
        let resolver = Resolver(maxRecursiveDepth: 10)
        closure?(resolver)
        return resolver
    }

    // MARK: - Functions

    func checkParentWithChild(closure: RegisterClosure?) {
        it("test register/resolve parent/child") {
            let resolver = self.register(closure: closure)
            let parent: ParentProtocol? = resolver.resolve()
            expect(parent).toNot(beNil())
            expect(parent?.child).toNot(beNil())
            expect(parent?.child?.parent).to(beNil())
        }
    }

    func checkOptionalStrong(closure: RegisterClosure?) {
        it("test register/resolve optional/strong") {
            let resolver = self.register(closure: closure)
            let child = resolver.resolve(ChildProtocol.self)
            expect(child).toNot(beNil())
        }
    }
}
